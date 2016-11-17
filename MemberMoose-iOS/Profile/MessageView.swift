//
//  MessageView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/17/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SlackTextViewController

protocol MessageViewDelegate:class {
    func didSubmitMessage(message: String)
}
class MessageView: SLKTextViewController {
    weak var messageViewDelegate: MessageViewDelegate?
    
    var dataSource: [Message] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    init() {
        super.init(tableViewStyle: .plain)
        
        configureTableView()
    }
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureTableView() {
        isInverted = false
        
        if let tableView = tableView {
            tableView.tableFooterView = UIView()
            tableView.scrollsToTop = true
            tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
            let controller = UITableViewController()
            controller.tableView = self.tableView
            //controller.refreshControl = refreshControl
            tableView.separatorColor = .clear
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200.0
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let model = dataSource[indexPath.row]
        cell.setupWith(model)
        cell.layoutSubviews()

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }
}
extension MessageView {
    
//    override func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text.isIncludingEmoji() {
//            textView.text = text.stringByRemovingEmoji() as String
//            
//            return false
//        }
//        
//        return true
//    }
    
//    override func didPressLeftButton(sender: AnyObject!) {
//        if imageToPost != nil {
//            let editPhotoController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//            let replaceAction = UIAlertAction(title: "Replace Photo", style: .Default) { _ in
//                self.presentPicker()
//            }
//            let removeAction = UIAlertAction(title: "Remove Photo", style: .Default) { _ in
//                self.removePhoto()
//            }
//            let cancelAction = UIAlertAction(title: NSLocalizedString("Common_Cancel", comment: ""), style: .Cancel, handler: nil)
//            
//            editPhotoController.addAction(cancelAction)
//            editPhotoController.addAction(replaceAction)
//            editPhotoController.addAction(removeAction)
//            presentViewController(editPhotoController, animated: true, completion: nil)
//        } else {
//            presentPicker()
//        }
//        
//        super.didPressLeftButton(sender)
//    }
//    
//    func presentPicker() {
//        ImagePicker.presentOn(self, thumbnailCompletion: { [weak self] image in
//            if let image = image {
//                let orientedImage = UIImage.getRotatedImageFromImage(image)
//                self?.addThumbnail(orientedImage)
//            }
//            }, completion: { [weak self] image in
//                if let image = image {
//                    let orientedImage = UIImage.getRotatedImageFromImage(image)
//                    self?.addImage(orientedImage)
//                }
//        })
//    }
//    
//    func addImage(image: UIImage) {
//        imageToPost = image
//    }
//    
//    func addThumbnail(image: UIImage) {
//        thumbnailView.image = image
//    }
//    
//    func removePhoto() {
//        imageToPost = nil
//        thumbnailView.image = nil
//    }
    
    override func didPressRightButton(_ sender: Any?) {
        defer {
            super.didPressRightButton(sender)
            dismissKeyboard(true)
        }
        
        //call endpoint to post message probably in VC
        //setTextInputbarHidden(true, animated: true)

        if let message = textView.text {
            messageViewDelegate?.didSubmitMessage(message: message)
        }
    }
    override func didCommitTextEditing(_ sender: Any) {
        defer {
            super.didCommitTextEditing(sender)
            dismissKeyboard(true)
        }
    }
    override func didCancelTextEditing(_ sender: Any) {
        dismissKeyboard(true)
        super.didCancelTextEditing(sender)
    }
    

}
