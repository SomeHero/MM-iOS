//
//  SignUpViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var avatar: UIImage?
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
    private lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        _photoView.buttonTitle = "Upload Your Logo"
        _photoView.editPhotoButton.addTarget(self, action: #selector(SignUpViewController.editPhotoClicked), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_photoView)
        return _photoView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.companyNameTextField, self.emailTextField, self.passwordTextField])
        stack.axis = .Vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var companyNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Company Name", placeholder: "Company Name", tag: 101)
        self.configureTextField(_textField.textField)
        
//        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
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
        
        _button.addTarget(self, action: #selector(JoinViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        avatarView.snp_updateConstraints { (make) in
            make.top.equalTo(backButton.snp_bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stackView.snp_updateConstraints { (make) in
            make.top.equalTo(avatarView.snp_bottom).offset(60)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(stackView.snp_bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView)
        }
    }
    
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func nextClicked(sender: UIButton) {
        let viewController = CreateFirstPlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
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
    func addImage(image: UIImage) {
        avatarView.profilePhoto.image = image
        
        avatar = image
    }
    func resetScrollViewInsets() {
        UIView.animateWithDuration(0.2) {
            let contentInsets = UIEdgeInsetsZero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension SignUpViewController : InputNavigationDelegate {
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
            
            let isFirstItem = activeField == companyNameTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].enabled = !isFirstItem
        }
    }
}
