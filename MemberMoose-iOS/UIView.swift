//
//  UIView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

extension UIView {
    func systemLayoutHeightForWidth(width: CGFloat) -> CGFloat {
        var fittingSize = UILayoutFittingCompressedSize
        fittingSize.width = width
        let size = self.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
        
        return size.height
    }
    
}
