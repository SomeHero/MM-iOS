//
//  ButtonDecorator.swift
//  PersonalShopper
//
//  Created by James Rhodes on 9/3/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ButtonDecorator: NSObject {
    static func applyDefaultStyle(_ button: UIButton) {
        button.backgroundColor = UIColorTheme.Primary
        button.titleLabel?.font = UIFontTheme.Regular(.large)
        button.titleLabel?.textColor = UIColorTheme.PrimaryForeground
        button.layer.borderColor = UIColor.flatBlue().cgColor
        button.setTitleColor(UIColorTheme.PrimaryForeground, for: UIControlState())
        button.setTitleColor(UIColorTheme.PrimaryForeground, for: .highlighted)
        button.addTarget(self, action: #selector(ButtonDecorator.beginButtonPress(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(ButtonDecorator.endButtonPress(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchCancel])
    }
    static func applyLinkStyle(_ button: UIButton) {
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.flatBlue(), for: UIControlState())
        button.setTitleColor(UIColor.flatBlueColorDark(), for: .highlighted)
    }
    static func beginButtonPress(_ sender: UIButton) {
        sender.backgroundColor = UIColorTheme.PrimaryTransparent
    }
    static func endButtonPress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            sender.backgroundColor = UIColorTheme.Primary
        }) 
    }
}
