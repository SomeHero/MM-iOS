//
//  UIFontTheme.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

struct UIFontTheme {
    enum FontName: String {
        case Regular = "OpenSans"
        case Bold    = "OpenSans-Bold"
        case SemiBold    = "OpenSans-Semibold"
        case Italic  = "OpenSans-Italic"
        case Light   = "OpenSans-Light"
        case Icon    = "FontAwesome"
    }
    enum FontSize: CGFloat {
        case XTiny = 11
        case Tiny = 13
        case Small = 16
        case Default = 18
        case Large = 21
        case XLarge = 26
        case Huge = 30
    }
    static let defaultSize: FontSize = .Default
    
    static func Regular(size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Regular.rawValue, size: size.rawValue)!
    }
    
    static func Bold(size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Bold.rawValue, size: size.rawValue)!
    }
    
    static func Italic(size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Italic.rawValue, size: size.rawValue)!
    }
    
    static func Light(size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Light.rawValue, size: size.rawValue)!
    }
    
    static func Icon(size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Icon.rawValue, size: size.rawValue)!
    }
    
    static func newFont(name: FontName, size: FontSize = defaultSize) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size.cgFloatValue) else {
            fatalError("Unable to load font: \(name.rawValue)")
        }
        return font
    }
}
extension UIFontTheme.FontSize {
    var cgFloatValue: CGFloat {
        return CGFloat(self.rawValue)
    }
}
