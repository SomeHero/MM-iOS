//
//  StetchyHeaderLayout.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/8/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class StretchyHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scrollDirection = .vertical
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let insets = collectionView.contentInset
        let offset = collectionView.contentOffset
        
        let minY = -insets.top
        
        // Check if we've pulled below past the lowest position
        if offset.y < minY {
            // Figure out how much we've pulled down
            let deltaY = fabs(offset.y - minY)
            
            for attrs in attributes where attrs.representedElementKind == UICollectionElementKindSectionHeader {
                // Adjust the header's height and y based on how much the user has pulled down.
                let headerSize = headerReferenceSize
                var headerRect = attrs.frame
                
                headerRect.size.height = max(minY, headerSize.height + deltaY)
                headerRect.origin.y = headerRect.origin.y - deltaY
                
                attrs.frame = headerRect
                
                break
            }
        }
        
        return attributes
    }
}
