//
//  File.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/12/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SnapKit

private let photoSize: CGFloat = 120

class EditProfilePhotoView: UIView {
    
    // MARK: - Lazy views
    
    lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "JoinAvatar"))
        imageView.layer.cornerRadius = photoSize / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        return imageView
    }()
    lazy var overlayView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.blackColor()
        _view.alpha = 0.4
        
        self.profilePhoto.addSubview(_view)
        return _view
    }()
    lazy var editPhotoButton: UIButton = {
        let button = UIButton()
        
        ButtonDecorator.applyLinkStyle(button)
        button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.lineBreakMode = .ByWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.flatWhiteColorDark(), forState: .Highlighted)

        self.addSubview(button)
        return button
    }()
    
    var buttonTitle: String = "" {
        didSet {
            editPhotoButton.setTitle(buttonTitle, forState: .Normal)
        }
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        
        profilePhoto.snp_updateConstraints { (make) -> Void in
            make.top.bottom.equalTo(self).offset(20)
            make.centerX.equalTo(self)
            make.height.equalTo(photoSize)
            make.width.equalTo(photoSize)
        }
        overlayView.snp_updateConstraints { (make) -> Void in
            make.edges.equalTo(self.profilePhoto)
        }
        editPhotoButton.snp_updateConstraints { (make) -> Void in
            make.center.equalTo(self.profilePhoto)
            make.width.height.equalTo(photoSize)
        }
        self.bringSubviewToFront(self.editPhotoButton)
        
        super.updateConstraints()
    }
    
    // MARK: - Public methods
    
    func setPhoto(photo: UIImage?) {
        //        if let photo = photo {
        //            profilePhoto.setImageWithFade(photo)
        //        } else if let placeholderPhoto = Image.noCouplePhotoJoin {
        //            profilePhoto.setImageWithFade(placeholderPhoto)
        //        }
    }

}
