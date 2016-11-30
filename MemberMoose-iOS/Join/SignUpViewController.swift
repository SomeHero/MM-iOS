//
//  SignUpViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {
    var avatar: UIImage?
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
    fileprivate lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        _photoView.buttonTitle = "Upload Your Logo"
        _photoView.editPhotoButton.addTarget(self, action: #selector(SignUpViewController.editPhotoClicked), for: .touchUpInside)
        
        self.scrollView.addSubview(_photoView)
        return _photoView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.companyNameTextField, self.emailTextField, self.passwordTextField])
        stack.axis = .vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var companyNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "COMPANY NAME", tag: 101)
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(SignUpViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "EMAIL", tag: 102)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(SignUpViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var passwordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "PASSWORD", tag: 103)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.isSecureTextEntry = true
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(SignUpViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(JoinViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        validateForm()
        // Do any additional setup after loading the view, typically from a nib.
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
        avatarView.snp.updateConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView)
        }
    }
    
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    func nextClicked(_ sender: UIButton) {
        guard let companyName = companyNameTextField.textField.text, let emailAddress = emailTextField.textField.text, let password = passwordTextField.textField.text else {
            return
        }
        let createUser = CreateUser(emailAddress: emailAddress, password: password, companyName: companyName, avatar: avatar)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.createUser(createUser, success: { (userId, token) in
            SessionManager.sharedInstance.setToken(token)
            
            ApiManager.sharedInstance.me({ (response) in
                SVProgressHUD.dismiss()
                
                SessionManager.sharedUser = response
                SessionManager.persistUser()
                
                let viewController = CreateFirstPlanViewController()
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }, failure: {[weak self] (error, errorDictionary) in
                SVProgressHUD.dismiss()
                
                guard let _self = self else {
                    return
                }
                
                ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
            })
        }) {[weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        textField.delegate = self

        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func editPhotoClicked() {
        ImagePicker.presentOn(self) { [weak self] image in
            if let image = image {
                let orientedImage = UIImage.getRotatedImageFromImage(image)
                
                self?.addImage(orientedImage)
            }
        }
    }
    func addImage(_ image: UIImage) {
        avatarView.profilePhoto.image = image
        
        avatar = image
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }) 
    }
    func validateForm() {
        guard let companyName = companyNameTextField.textField.text else {
            return
        }
        let companyNameValid = Validator.isValidText(companyName)
        
        guard let emailAddress = emailTextField.textField.text else {
            return
        }
        let emailAddressValid = Validator.isValidEmail(emailAddress)
        
        guard let password = passwordTextField.textField.text else {
            return
        }
        let passwordValid = Validator.isValidText(password)
        
        if companyNameValid && emailAddressValid && passwordValid {
            enableButton(nextButton)
        } else {
            disableButton(nextButton)
        }
    }
}
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension SignUpViewController : InputNavigationDelegate {
    func keyboardDidAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
            
            let isFirstItem = activeField == companyNameTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
