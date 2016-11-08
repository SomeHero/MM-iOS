//
//  UIImage.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/12/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

extension UIImage {
    static func getRotatedImageFromImage(_ imageToRotate:UIImage) -> UIImage{
        if imageToRotate.imageOrientation == UIImageOrientation.up {
            return imageToRotate
        } else if imageToRotate.imageOrientation == UIImageOrientation.right {
            return imageToRotate.imageRotatedByDegrees(90)
        } else if imageToRotate.imageOrientation == UIImageOrientation.down {
            return imageToRotate.imageRotatedByDegrees(180)
        } else {
            return imageToRotate.imageRotatedByDegrees(270)
        }
    }
    
    public func imageRotatedByDegrees(_ degrees: CGFloat) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = size //rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        
        // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees))
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(cgImage!, in: CGRect(x: -size.height / 2, y: -size.width / 2, width: size.height, height: size.width))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
