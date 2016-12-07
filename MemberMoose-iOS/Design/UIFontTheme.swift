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
        case xTiny = 11
        case tiny = 14
        case small = 16
        case `default` = 18
        case large = 20
        case xLarge = 26
        case huge = 30
    }
    static let defaultSize: FontSize = .default
    
    static func Regular(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Regular.rawValue, size: size.rawValue)!
    }
    
    static func Bold(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Bold.rawValue, size: size.rawValue)!
    }
    
    static func Italic(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Italic.rawValue, size: size.rawValue)!
    }
    
    static func Light(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Light.rawValue, size: size.rawValue)!
    }
    
    static func SemiBold(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.SemiBold.rawValue, size: size.rawValue)!
    }
    static func Icon(_ size: FontSize = defaultSize) -> UIFont {
        return UIFont(name: FontName.Icon.rawValue, size: size.rawValue)!
    }
    
    static func newFont(_ name: FontName, size: FontSize = defaultSize) -> UIFont {
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
