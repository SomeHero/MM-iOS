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
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    fileprivate lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        _photoView.buttonTitle = "Upload Your Logo"
        _photoView.editPhotoButton.addTarget(self, action: #selector(BullProfileViewController.editPhotoClicked), for: .touchUpInside)
        
        self.scrollView.addSubview(_photoView)
        return _photoView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.avatarView, self.companyNameTextField, self.subDomainTextField])
        stack.axis = .vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var companyNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Company Name", placeholder: "Enter Company Name", tag: 101)
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(BullProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var subDomainTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Sub-Domain", placeholder: "Enter Sub-Domain", tag: 102)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(BullProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(BullProfileViewController.nextClicked(_:)), for: .touchUpInside)
        
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
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(BullProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .white
        
        setup()
        validateForm()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardDidAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView).inset(20)
        }
    }
    func setup() {
        if let avatar = user.avatar, let avatarImageUrl = avatar["large"] {
            avatarView.profilePhoto.kf.setImage(with: URL(string: avatarImageUrl)!,
                                    placeholder: UIImage(named: "Avatar-Bull"))
        } else {
            avatarView.profilePhoto.image = UIImage(named: "Avatar-Bull")
        }
        companyNameTextField.textField.text = user.account?.companyName
        subDomainTextField.textField.text = user.account?.subdomain
    }
    func backClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func nextClicked(_ sender: UIButton) {
        guard let companyName = companyNameTextField.textField.text, let subDomain = subDomainTextField.textField.text else {
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension BullProfileViewController : InputNavigationDelegate {
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
            let isLastItem = activeField == subDomainTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == companyNameTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
