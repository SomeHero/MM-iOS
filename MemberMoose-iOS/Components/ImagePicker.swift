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

typealias ImagePickerCompletionBlock = (_ image: UIImage?) -> Void
typealias MediaPermissionBlock = (_ granted: Bool, _ previouslyRequested: Bool) -> Void

final class ImagePicker: NSObject {
    
    fileprivate static let sharedInstance = ImagePicker()
    fileprivate var completionBlock: ImagePickerCompletionBlock?
    fileprivate var thumbnailCompletionBlock: ImagePickerCompletionBlock?
    fileprivate var fetchThumbnail: Bool = false
    
    override init() {
        super.init()
    }
    
    // MARK: - Image picker
    
    class func presentOn(_ controller: UIViewController, thumbnailCompletion: ImagePickerCompletionBlock? = nil, completion: @escaping ImagePickerCompletionBlock) {
        requestLibraryAccess { granted, previouslyRequested in
            if granted {
                sharedInstance.presentOn(controller, completion: completion, thumbnailCompletion: thumbnailCompletion)
            } else if previouslyRequested {
                sharedInstance.showPermissionDeniedAlertWithMessage(NSLocalizedString("Error_Message_PhotoSettings", comment: ""), controller: controller)
            }
        }
    }
    
    fileprivate func presentOn(_ controller: UIViewController, completion: @escaping ImagePickerCompletionBlock, thumbnailCompletion: ImagePickerCompletionBlock?) {
        completionBlock = completion
        thumbnailCompletionBlock = thumbnailCompletion
        
        let imagePicker = ImagePickerSheetController(mediaType: .image)
        imagePicker.maximumSelection = 1
        
        let takePhotoAction = ImagePickerAction(title: NSLocalizedString("Take Photo", comment: "Action Title"), secondaryTitle: "", handler: { _ in
            ImagePicker.requestCameraAccess { granted, previouslyRequested in
                if granted {
                    self.presentImagePickerController(.camera, controller: controller)
                } else if previouslyRequested {
                    self.showPermissionDeniedAlertWithMessage(NSLocalizedString("Error_Message_CameraSettings", comment: ""), controller: controller)
                }
            }
            }, secondaryHandler: { _, numberOfPhotos in
                self.addImageAssets(imagePicker.selectedAssets)
        })
        
        let choosePhotoAction = ImagePickerAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: {
            NSString.localizedStringWithFormat(NSLocalizedString("Add Photo", comment: "Action Title") as NSString, $0) as String
            }, handler: { _ in
                self.presentImagePickerController(.photoLibrary, controller: controller)
            }, secondaryHandler: { _, numberOfPhotos in
                self.addImageAssets(imagePicker.selectedAssets)
        })
        
        let cancelAction = ImagePickerAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .cancel, handler: { _ in
            print("Cancelled")
        })
        
        imagePicker.addAction(takePhotoAction)
        imagePicker.addAction(choosePhotoAction)
        imagePicker.addAction(cancelAction)
        
        controller.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func showPermissionDeniedAlertWithMessage(_ message: String, controller: UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("Error_Title_Ouch", comment: ""), message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Error_Action_GoToSettings", comment: ""), style: .default) { _ in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Common_NoThanks", comment: ""), style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentImagePickerController(_ source: UIImagePickerControllerSourceType, controller: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        var sourceType = source
        if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            sourceType = .photoLibrary
            print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
        }
        imagePicker.sourceType = sourceType
        
        controller.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func addImageAssets(_ assets: [PHAsset]) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        let manager = PHImageManager.default()
        
        // Right now the API limits us to just one photo
        if let asset = assets.first {
            manager.requestImage(for: asset, targetSize: imageScaledSize, contentMode: .aspectFit, options: options, resultHandler: { [weak self] (image, _) -> Void in
                guard let _self = self else {
                    return
                }
                
                _self.callCompletionHandlersForImage(image)
                })
        }
    }
    
    fileprivate func resizedImageFor(_ image: UIImage) -> UIImage {
        return image.resizedImageToFit(in: imageScaledSize, scaleIfSmaller: false)
    }
    
    fileprivate func thumbnailImageFor(_ image: UIImage) -> UIImage {
        return image.resizedImageToFit(in: previewImageSize, scaleIfSmaller: false)
    }
    
    fileprivate func callCompletionHandlersForImage(_ image: UIImage?) {
        if let image = image {
            if let completion = completionBlock {
                let resizedImage = resizedImageFor(image)
                completion(resizedImage)
            }
            
            if let thumbnailCompletion = thumbnailCompletionBlock {
                let thumbnailImage = thumbnailImageFor(image)
                thumbnailCompletion(thumbnailImage)
            }
        } else {
            completionBlock?(nil)
            thumbnailCompletionBlock?(nil)
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
    
    fileprivate static func getImageFileURLFor(_ user: User) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        var url = urls.last!.appendingPathComponent("isa_userImage_\(user.id)")
        url = url.appendingPathExtension("png")
        
        return url
    }
    
    fileprivate static func requestCameraAccess(_ completion: @escaping MediaPermissionBlock) {
        let previouslyRequested = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .notDetermined ? false : true
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { granted in
            DispatchQueue.main.async {
                completion(granted, previouslyRequested)
            }
        })
    }
    
    fileprivate static func requestLibraryAccess(_ completion: @escaping MediaPermissionBlock) {
        let previouslyRequested = PHPhotoLibrary.authorizationStatus() == .notDetermined ? false : true
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    completion(true, previouslyRequested)
                default:
                    completion(false, previouslyRequested)
                }
            }
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        picker.dismiss(animated: true) { [weak self] in
            self?.callCompletionHandlersForImage(image)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let _self = self else { return }
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                _self.callCompletionHandlersForImage(image)
            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                _self.callCompletionHandlersForImage(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let _self = self else { return }
            
            _self.callCompletionHandlersForImage(nil)
        }
    }
}
