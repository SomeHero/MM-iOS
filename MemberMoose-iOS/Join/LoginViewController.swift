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
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    fileprivate lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "Back"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(SignUpViewController.backClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "Logo")
        _imageView.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(_imageView)
        return _imageView
    }()
    fileprivate lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.scrollView.addSubview(_label)
        
        return _label
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField])
        stack.axis = .vertical
        stack.spacing = 30
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "EMAIL", tag: 101)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(LoginViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var passwordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "PASSWORD", tag: 102)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.isSecureTextEntry = true
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(LoginViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(LoginViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
        validateForm()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardDidAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        backButton.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(35)
            make.leading.equalTo(scrollView).inset(15)
            make.height.equalTo(18)
        }
        logo.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(140)
        }
        introLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(60)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(introLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(scrollView).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView)
        }
    }
    func nextClicked(_ sender: UIButton) {
        let authenticateUser = AuthenticateUser(emailAddress: emailTextField.textField.text!.lowercased(), password: passwordTextField.textField.text!)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.authenticate(authenticateUser, success: { (userId, token) in
            SessionManager.sharedInstance.setToken(token)
            
            ApiManager.sharedInstance.me({ (response) in
                SVProgressHUD.dismiss()
                
                SessionManager.sharedUser = response
                SessionManager.persistUser()
                
                let viewController = ProfileViewController(user: response, profileType: .bull)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.isNavigationBarHidden = true
                
                let menuViewController = MenuViewController()
                
                let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
                
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    delegate.swRevealViewController = swRevealViewController
                    
                    delegate.window?.rootViewController?.present(swRevealViewController!, animated: true, completion: nil)
                }
            }, failure: { [weak self] (error, errorDictionary) in
                SVProgressHUD.dismiss()
                
                guard let _self = self else {
                    return
                }
                
                ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
            })
            
        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
    func backClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
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
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }) 
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension LoginViewController : InputNavigationDelegate {
    func keyboardDidAppear(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
            let keyboardHeight = keyboardSize.height
                
            UIView.animate(withDuration: 0.2, animations: {
                let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
            })
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
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
    
    func toggleKeyboardNavButtonsEnabled(_ toolBar: UIToolbar) {
        if let items = toolBar.items {
            let isLastItem = activeField == passwordTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == emailTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
