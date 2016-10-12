//
//  UIImage.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/12/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

extension UIImage {
    static func getRotatedImageFromImage(imageToRotate:UIImage) -> UIImage{
        if imageToRotate.imageOrientation == UIImageOrientation.Up {
            return imageToRotate
        } else if imageToRotate.imageOrientation == UIImageOrientation.Right {
            return imageToRotate.imageRotatedByDegrees(90)
        } else if imageToRotate.imageOrientation == UIImageOrientation.Down {
            return imageToRotate.imageRotatedByDegrees(180)
        } else {
            return imageToRotate.imageRotatedByDegrees(270)
        }
    }
    
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = size //rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0)
        
        // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        CGContextScaleCTM(bitmap, 1.0, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.height / 2, -size.width / 2, size.height, size.width), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}