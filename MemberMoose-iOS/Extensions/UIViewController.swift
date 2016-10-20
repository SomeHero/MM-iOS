//
//  UIViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureStatusBarStyle(style: UIStatusBarStyle = .LightContent, animated: Bool = true) {
        UIApplication.sharedApplication().setStatusBarStyle(style, animated: animated)
    }
    func configureRevealControllerGestures(view: UIView) {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate, revealController = delegate.swRevealViewController {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            view.addGestureRecognizer(revealController.tapGestureRecognizer())
        }
    }
    func configureRevealWidth() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate, revealController = delegate.swRevealViewController {
            revealController.rearViewRevealWidth = UIScreen.mainScreen().bounds.size.width * 0.85
        }
    }
    func toggleMenu(sender: UIButton) {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate, swRevealViewController = delegate.swRevealViewController {
            
            swRevealViewController.revealToggleAnimated(true)
        }
    }
    func enableButton(button: UIButton) {
        button.enabled = true
        
        UIView.animateWithDuration(0.3, animations: {
            button.alpha = 1
        })
    }
    func disableButton(button: UIButton, alpha: CGFloat = 0.5) {
        button.enabled = false
        
        UIView.animateWithDuration(0.3, animations: {
            button.alpha = alpha
        })
    }
}