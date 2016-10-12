//
//  ButtonDecorator.swift
//  PersonalShopper
//
//  Created by James Rhodes on 9/3/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ButtonDecorator: NSObject {
    static func applyDefaultStyle(button: UIButton) {
        button.backgroundColor = UIColorTheme.Primary
        button.titleLabel?.font = UIFontTheme.Regular(.Large)
        button.titleLabel?.textColor = UIColorTheme.PrimaryForeground
        button.layer.borderColor = UIColor.flatBlueColor().CGColor
        button.setTitleColor(UIColorTheme.PrimaryForeground, forState: .Normal)
        button.setTitleColor(UIColorTheme.PrimaryForeground, forState: .Highlighted)
        button.addTarget(self, action: #selector(ButtonDecorator.beginButtonPress(_:)), forControlEvents: .TouchDown)
        button.addTarget(self, action: #selector(ButtonDecorator.endButtonPress(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchCancel])
    }
    static func applyLinkStyle(button: UIButton) {
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.flatBlueColor(), forState: .Normal)
        button.setTitleColor(UIColor.flatBlueColorDark(), forState: .Highlighted)
    }
    static func beginButtonPress(sender: UIButton) {
        sender.backgroundColor = UIColorTheme.PrimaryTransparent
    }
    static func endButtonPress(sender: UIButton) {
        UIView.animateWithDuration(0.25) {
            sender.backgroundColor = UIColorTheme.Primary
        }
    }
}