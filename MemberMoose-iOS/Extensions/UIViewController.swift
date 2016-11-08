//
//  UIViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureStatusBarStyle(_ style: UIStatusBarStyle = .lightContent, animated: Bool = true) {
        UIApplication.shared.setStatusBarStyle(style, animated: animated)
    }
    func configureRevealControllerGestures(_ view: UIView) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let revealController = delegate.swRevealViewController {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            view.addGestureRecognizer(revealController.tapGestureRecognizer())
        }
    }
    func configureRevealWidth() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let revealController = delegate.swRevealViewController {
            revealController.rearViewRevealWidth = UIScreen.main.bounds.size.width * 0.85
        }
    }
    func toggleMenu(_ sender: UIButton) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let swRevealViewController = delegate.swRevealViewController {
            
            swRevealViewController.revealToggle(animated: true)
        }
    }
    func enableButton(_ button: UIButton) {
        button.isEnabled = true
        
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 1
        })
    }
    func disableButton(_ button: UIButton, alpha: CGFloat = 0.5) {
        button.isEnabled = false
        
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = alpha
        })
    }
}
