//
//  ImagePicker.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/12/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import ImagePickerSheetController
import ASImageResize

private let imageScaledSize = CGSize(width: 800, height: 800)
private let previewImageSize = CGSize(width: 30, height: 30)

typealias ImagePickerCompletionBlock = (image: UIImage?) -> Void
typealias MediaPermissionBlock = (granted: Bool, previouslyRequested: Bool) -> Void

final class ImagePicker: NSObject {
    
    private static let sharedInstance = ImagePicker()
    private var completionBlock: ImagePickerCompletionBlock?
    private var thumbnailCompletionBlock: ImagePickerCompletionBlock?
    private var fetchThumbnail: Bool = false
    
    override init() {
        super.init()
    }
    
    // MARK: - Image picker
    
    class func presentOn(controller: UIViewController, thumbnailCompletion: ImagePickerCompletionBlock? = nil, completion: ImagePickerCompletionBlock) {
        requestLibraryAccess { granted, previouslyRequested in
            if granted {
                sharedInstance.presentOn(controller, completion: completion, thumbnailCompletion: thumbnailCompletion)
            } else if previouslyRequested {
                sharedInstance.showPermissionDeniedAlertWithMessage(NSLocalizedString("Error_Message_PhotoSettings", comment: ""), controller: controller)
            }
        }
    }
    
    private func presentOn(controller: UIViewController, completion: ImagePickerCompletionBlock, thumbnailCompletion: ImagePickerCompletionBlock?) {
        completionBlock = completion
        thumbnailCompletionBlock = thumbnailCompletion
        
        let imagePicker = ImagePickerSheetController(mediaType: .Image)
        imagePicker.maximumSelection = 1
        
        let takePhotoAction = ImagePickerAction(title: NSLocalizedString("Take Photo", comment: "Action Title"), secondaryTitle: "", handler: { _ in
            ImagePicker.requestCameraAccess { granted, previouslyRequested in
                if granted {
                    self.presentImagePickerController(.Camera, controller: controller)
                } else if previouslyRequested {
                    self.showPermissionDeniedAlertWithMessage(NSLocalizedString("Error_Message_CameraSettings", comment: ""), controller: controller)
                }
            }
            }, secondaryHandler: { _, numberOfPhotos in
                self.addImageAssets(imagePicker.selectedImageAssets)
        })
        
        let choosePhotoAction = ImagePickerAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: {
            NSString.localizedStringWithFormat(NSLocalizedString("Add Photo", comment: "Action Title"), $0) as String
            }, handler: { _ in
                self.presentImagePickerController(.PhotoLibrary, controller: controller)
            }, secondaryHandler: { _, numberOfPhotos in
                self.addImageAssets(imagePicker.selectedImageAssets)
        })
        
        let cancelAction = ImagePickerAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
            print("Cancelled")
        })
        
        imagePicker.addAction(takePhotoAction)
        imagePicker.addAction(choosePhotoAction)
        imagePicker.addAction(cancelAction)
        
        controller.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    private func showPermissionDeniedAlertWithMessage(message: String, controller: UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("Error_Title_Ouch", comment: ""), message: message, preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Error_Action_GoToSettings", comment: ""), style: .Default) { _ in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Common_NoThanks", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func presentImagePickerController(source: UIImagePickerControllerSourceType, controller: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        var sourceType = source
        if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            sourceType = .PhotoLibrary
            print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
        }
        imagePicker.sourceType = sourceType
        
        controller.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    private func addImageAssets(assets: [PHAsset]) {
        let options = PHImageRequestOptions()
        options.synchronous = true
        
        let manager = PHImageManager.defaultManager()
        
        // Right now the API limits us to just one photo
        if let asset = assets.first {
            manager.requestImageForAsset(asset, targetSize: imageScaledSize, contentMode: .AspectFit, options: options, resultHandler: { [weak self] (image, _) -> Void in
                guard let _self = self else {
                    return
                }
                
                _self.callCompletionHandlersForImage(image)
                })
        }
    }
    
    private func resizedImageFor(image: UIImage) -> UIImage {
        return image.resizedImageToFitInSize(imageScaledSize, scaleIfSmaller: false)
    }
    
    private func thumbnailImageFor(image: UIImage) -> UIImage {
        return image.resizedImageToFitInSize(previewImageSize, scaleIfSmaller: false)
    }
    
    private func callCompletionHandlersForImage(image: UIImage?) {
        if let image = image {
            if let completion = completionBlock {
                let resizedImage = resizedImageFor(image)
                completion(image: resizedImage)
            }
            
            if let thumbnailCompletion = thumbnailCompletionBlock {
                let thumbnailImage = thumbnailImageFor(image)
                thumbnailCompletion(image: thumbnailImage)
            }
        } else {
            completionBlock?(image: nil)
            thumbnailCompletionBlock?(image: nil)
        }
    }
    
    // MARK: - Persisted image
    
//    static func removeUserImage() {
//        do {
//            guard let user = User.sharedUser else {
//                return
//            }
//            
//            try NSFileManager.defaultManager().removeItemAtURL(ImagePicker.getImageFileURLFor(user))
//        } catch {
//            print("Attempting to remove user image failed with error: \(error) ")
//        }
//    }
//    
//    static func setUserImage(image: UIImage) -> Bool {
//        guard let user = User.sharedUser else {
//            return false
//        }
//        
//        guard let data = UIImagePNGRepresentation(image) else {
//            return false
//        }
//        
//        return data.writeToURL(ImagePicker.getImageFileURLFor(user), atomically: true)
//    }
//    
//    static func getUserImage() -> UIImage? {
//        
//        guard let user = User.sharedUser else {
//            return nil
//        }
//        
//        if let data = NSData(contentsOfURL: ImagePicker.getImageFileURLFor(user)) {
//            return UIImage(data: data)
//        }
//        
//        return nil
//    }
    
    private static func getImageFileURLFor(user: User) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        var url = urls.last!.URLByAppendingPathComponent("isa_userImage_\(user.id)")
        url = url.URLByAppendingPathExtension("png")
        
        return url
    }
    
    private static func requestCameraAccess(completion: MediaPermissionBlock) {
        let previouslyRequested = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .NotDetermined ? false : true
        
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
            dispatch_async(dispatch_get_main_queue()) {
                completion(granted: granted, previouslyRequested: previouslyRequested)
            }
        })
    }
    
    private static func requestLibraryAccess(completion: MediaPermissionBlock) {
        let previouslyRequested = PHPhotoLibrary.authorizationStatus() == .NotDetermined ? false : true
        
        PHPhotoLibrary.requestAuthorization { status in
            dispatch_async(dispatch_get_main_queue()) {
                switch status {
                case .Authorized:
                    completion(granted: true, previouslyRequested: previouslyRequested)
                default:
                    completion(granted: false, previouslyRequested: previouslyRequested)
                }
            }
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            self?.callCompletionHandlersForImage(image)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            guard let _self = self else { return }
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                _self.callCompletionHandlersForImage(image)
            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                _self.callCompletionHandlersForImage(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            guard let _self = self else { return }
            
            _self.callCompletionHandlersForImage(nil)
        }
    }
}