//
//  LoginViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController
import SVProgressHUD

class LoginViewController: UIViewController {
    var activeField: UITextField?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    private lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "Back"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(SignUpViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "Logo")
        _imageView.contentMode = .ScaleAspectFit
        
        self.scrollView.addSubview(_imageView)
        return _imageView
    }()
    private lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.scrollView.addSubview(_label)
        
        return _label
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField])
        stack.axis = .Vertical
        stack.spacing = 30
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Email", placeholder: "Email Address", tag: 101)
        _textField.textField.autocorrectionType = .No
        _textField.textField.autocapitalizationType = .None
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(LoginViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var passwordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Password", placeholder: "Password", tag: 102)
        _textField.textField.autocorrectionType = .No
        _textField.textField.autocapitalizationType = .None
        _textField.textField.secureTextEntry = true
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(LoginViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
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
        setup()
        
        validateForm()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardDidAppear(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp_updateConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(UIScreen.mainScreen().bounds.width)
        }
        backButton.snp_updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(35)
            make.leading.equalTo(scrollView).inset(15)
            make.height.equalTo(18)
        }
        logo.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp_bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(140)
        }
        introLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(60)
        }
        stackView.snp_updateConstraints { (make) in
            make.top.equalTo(introLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(scrollView).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(stackView.snp_bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
        }
    }
    func nextClicked(sender: UIButton) {
        let authenticateUser = AuthenticateUser(emailAddress: emailTextField.textField.text!.lowercaseString, password: passwordTextField.textField.text!)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.authenticate(authenticateUser, success: { (userId, token) in
            SessionManager.sharedInstance.setToken(token)
            
            ApiManager.sharedInstance.me({ (response) in
                SVProgressHUD.dismiss()
                
                SessionManager.sharedUser = response
                SessionManager.persistUser()
                
                let viewController = MembersViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBarHidden = true
                
                let menuViewController = MenuViewController()
                
                let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
                
                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    delegate.swRevealViewController = swRevealViewController
                    
                    delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
                }
            }, failure: { (error, errorDictionary) in
                print("error occurred")
                
                SVProgressHUD.dismiss()
            })
            
        }) { (error, errorDictionary) in
            print("error occurred")
            
            SVProgressHUD.dismiss()
        }
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
        textField.delegate = self

        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func setup() {
        introLabel.text = "Sign In to MemberMoose"
    }
    func validateForm() {
        guard let emailAddress = emailTextField.textField.text else {
            return
        }
        let emailAddressValid = Validator.isValidEmail(emailAddress)
        
        guard let password = passwordTextField.textField.text else {
            return
        }
        let passwordValid = Validator.isValidText(password)
        
        if emailAddressValid && passwordValid {
            enableButton(nextButton)
        } else {
            disableButton(nextButton)
        }
    }
    func resetScrollViewInsets() {
        UIView.animateWithDuration(0.2) {
            let contentInsets = UIEdgeInsetsZero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension LoginViewController : InputNavigationDelegate {
    func keyboardDidAppear(notification: NSNotification) {
        if let info = notification.userInfo {
            if let keyboardSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size {
                let keyboardHeight = keyboardSize.height
                
                UIView.animateWithDuration(0.2) {
                    let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
                    self.scrollView.contentInset = contentInsets
                    self.scrollView.scrollIndicatorInsets = contentInsets
                }
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        resetScrollViewInsets()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gotoPreviousInput() {
        if let activeField = activeField {
            let tag = activeField.tag
            
            let nextField = self.view.viewWithTag(tag-1)
            
            nextField?.becomeFirstResponder()
        }
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
    }
    
    func gotoNextInput() {
        if let activeField = activeField {
            let tag = activeField.tag
            
            let nextField = self.view.viewWithTag(tag+1)
            
            nextField?.becomeFirstResponder()
        }
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
    }
    
    func toggleKeyboardNavButtonsEnabled(toolBar: UIToolbar) {
        if let items = toolBar.items {
            let isLastItem = activeField == passwordTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].enabled = !isLastItem
            
            let isFirstItem = activeField == emailTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].enabled = !isFirstItem
        }
    }
}
