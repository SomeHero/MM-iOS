//
//  BullProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

class BullProfileViewController: UIViewController {
    var avatar: UIImage?
    var activeField: UITextField?
    let user: User
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    private lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        _photoView.buttonTitle = "Upload Your Logo"
        _photoView.editPhotoButton.addTarget(self, action: #selector(BullProfileViewController.editPhotoClicked), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_photoView)
        return _photoView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.avatarView, self.companyNameTextField, self.subDomainTextField])
        stack.axis = .Vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var companyNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Company Name", placeholder: "Enter Company Name", tag: 101)
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(BullProfileViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var subDomainTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Sub-Domain", placeholder: "Enter Sub-Domain", tag: 102)
        _textField.textField.autocorrectionType = .No
        _textField.textField.autocapitalizationType = .None
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(BullProfileViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(BullProfileViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Company Profile"
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(BullProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .whiteColor()
        
        setup()
        validateForm()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardDidAppear(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        stackView.snp_updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(stackView.snp_bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView).inset(20)
        }
    }
    func setup() {
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            avatarView.profilePhoto.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                    placeholderImage: UIImage(named: "Avatar-Bull"))
        } else {
            avatarView.profilePhoto.image = UIImage(named: "Avatar-Bull")
        }
        companyNameTextField.textField.text = user.account?.companyName
        subDomainTextField.textField.text = user.account?.subdomain
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func nextClicked(sender: UIButton) {
        guard let companyName = companyNameTextField.textField.text, subDomain = subDomainTextField.textField.text else {
            return
        }
//        let createUser = CreateUser(emailAddress: emailAddress, password: password, companyName: companyName, avatar: avatar)
//        
//        SVProgressHUD.show()
//        
//        ApiManager.sharedInstance.createUser(createUser, success: { (userId, token) in
//            SessionManager.sharedInstance.setToken(token)
//            
//            ApiManager.sharedInstance.me({ (response) in
//                SVProgressHUD.dismiss()
//                
//                SessionManager.sharedUser = response
//                SessionManager.persistUser()
//                
//                let viewController = CreateFirstPlanViewController()
//                
//                self.navigationController?.pushViewController(viewController, animated: true)
//                }, failure: { (error, errorDictionary) in
//                    print("error occurred")
//                    
//                    SVProgressHUD.dismiss()
//            })
//        }) { (error, errorDictionary) in
//            print("error occurred")
//            
//            SVProgressHUD.dismiss()
//        }
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
    func validateForm() {
        guard let companyName = companyNameTextField.textField.text else {
            return
        }
        let companyNameValid = Validator.isValidText(companyName)
        
        guard let subDomain = subDomainTextField.textField.text else {
            return
        }
        let subDomainValid = Validator.isValidText(subDomain)
        
        if companyNameValid && subDomainValid {
            enableButton(nextButton)
        } else {
            disableButton(nextButton)
        }
    }
}
extension BullProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension BullProfileViewController : InputNavigationDelegate {
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
            let isLastItem = activeField == subDomainTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].enabled = !isLastItem
            
            let isFirstItem = activeField == companyNameTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].enabled = !isFirstItem
        }
    }
}
