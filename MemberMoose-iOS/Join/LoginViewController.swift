//
//  LoginViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController

class LoginViewController: UIViewController {
    private lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "Back"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(SignUpViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "Logo")
        _imageView.contentMode = .ScaleAspectFit
        
        self.view.addSubview(_imageView)
        return _imageView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.view.addSubview(stack)
        return stack
    }()
    private lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Email", placeholder: "Email Address", tag: 102)
        _textField.textField.autocorrectionType = .No
        _textField.textField.autocapitalizationType = .None
        self.configureTextField(_textField.textField)
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var passwordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Password", placeholder: "Password", tag: 103)
        _textField.textField.autocorrectionType = .No
        _textField.textField.autocapitalizationType = .None
        _textField.textField.secureTextEntry = true
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(LoginViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        logo.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(view).inset(80)
            make.centerX.equalTo(view)
            make.height.equalTo(140)
        }
        stackView.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(stackView.snp_bottom).offset(40)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
    }
    func nextClicked(sender: UIButton) {
        let authenticateUser = AuthenticateUser(emailAddress: emailTextField.textField.text!.lowercaseString, password: passwordTextField.textField.text!)
        
        ApiManager.sharedInstance.authenticate(authenticateUser, success: { (userId, token) in
            SessionManager.sharedInstance.setToken(token)
            
            let viewController = MembersViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBarHidden = true
            
            let menuViewController = MenuViewController()
            
            let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
            
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.swRevealViewController = swRevealViewController
                
                delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
            }
        }) { (error, errorDictionary) in
            print("error occurred")
        }
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
        //        textField.delegate = self
        //
        //        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //        textField.inputAccessoryView = toolBar
    }
}
