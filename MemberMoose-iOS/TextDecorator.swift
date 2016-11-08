//
//  TextDecorator.swift
//  PersonalShopper
//
//  Created by James Rhodes on 9/3/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

struct TextDecorator {
    enum SpacingType {
        case roomy
        case tight
    }
    
    fileprivate static let tightLineHeightMultiple: CGFloat = 0.8
    fileprivate static let roomyLineHeightMultiple: CGFloat = 1.5
    
    static var roomyLineHeight: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = roomyLineHeightMultiple
        return style
    }()
    
    static var tightLineHeight: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineHeightMultiple = tightLineHeightMultiple
        return style
    }()
    static func applyTightLineHeight(toLabel label: UILabel) {
        guard let text = label.text else { return }
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = tightLineHeightMultiple
        style.alignment = label.textAlignment
        let attributes = [NSParagraphStyleAttributeName : style]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    static func applyRoomyLineHeight(toLabel label: UILabel) {
        guard let text = label.text else { return }
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = roomyLineHeightMultiple
        style.alignment = label.textAlignment
        let attributes = [NSParagraphStyleAttributeName : style]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    static func applyLineHeight(_ lineHeight: CGFloat, toLabel label: UILabel) {
        guard let text = label.text else { return }
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeight
        style.alignment = label.textAlignment
        let attributes = [NSParagraphStyleAttributeName : style]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
