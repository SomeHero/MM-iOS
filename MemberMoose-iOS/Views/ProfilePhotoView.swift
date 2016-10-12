//
//  PhotoView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SnapKit

private let photoSize: CGFloat = 100

class ProfilePhotoView: UIView {
    
    // MARK: - Lazy views
    
    lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grayColor()
        imageView.layer.cornerRadius = photoSize / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        self.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Layout
    
    override func updateConstraints() {
        
        profilePhoto.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(photoSize)
            make.width.equalTo(photoSize)
        }
        
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
