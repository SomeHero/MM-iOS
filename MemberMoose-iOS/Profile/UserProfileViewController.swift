//
//  CalfProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD
import FontAwesome_swift

protocol UserProfileDelegate: class {
    func didClickBack()
}
class UserProfileViewController: UIViewController {
    var avatar: UIImage?
    var activeField: UITextField?
    let user: User
    fileprivate let profileType: ProfileType
    weak var delegate: UserProfileDelegate?
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    lazy var closeButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 28)
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: .highlighted)
        _button.setTitle(String.fontAwesomeIcon(code: FontAwesome.remove.rawValue), for: .normal)
        _button.backgroundColor = UIColor.clear
        _button.addTarget(self, action: #selector(UserProfileViewController.closeClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        _photoView.buttonTitle = "Upload Avatar"
        _photoView.editPhotoButton.addTarget(self, action: #selector(UserProfileViewController.editPhotoClicked), for: .touchUpInside)
        
        self.scrollView.addSubview(_photoView)
        return _photoView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.avatarView, self.firstNameTextField, self.lastNameTextField, self.emailAddressTextField, self.passwordTextField, self.confirmPasswordTextField])
        stack.axis = .vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var firstNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Enter First Name", tag: 101)
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(UserProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var lastNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Enter Last Name", tag: 102)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(UserProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var emailAddressTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Enter Email Address", tag: 103)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.keyboardType = .emailAddress
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(UserProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var passwordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Enter Password", tag: 104)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.isSecureTextEntry = true
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(UserProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var confirmPasswordTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Enter Password Again", tag: 105)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.isSecureTextEntry = true
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(UserProfileViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(UserProfileViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    init(user: User, profileType: ProfileType) {
        self.user = user
        self.profileType = profileType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User Profile"

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
        closeButton.snp.updateConstraints { (make) in
            make.top.trailing.equalTo(view).inset(5)
            make.width.height.equalTo(40)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(40)
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
                                                       placeholder: UIImage(named: "Avatar-Calf"))
        } else {
            avatarView.profilePhoto.image = UIImage(named: "Avatar-Calf")
        }
        firstNameTextField.textField.text = user.firstName
        lastNameTextField.textField.text = user.lastName
        emailAddressTextField.textField.text = user.emailAddress
    }
    func closeClicked(_ sender: UIButton) {
        delegate?.didClickBack()
    }
    func nextClicked(_ sender: UIButton) {
        guard let firstName = firstNameTextField.textField.text, let lastName = lastNameTextField.textField.text, let emailAddress = emailAddressTextField.textField.text else {
            return
        }
        let updateUser = UpdateUser(userId: user.id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, avatar: avatar)
        
        SVProgressHUD.show()

        ApiManager.sharedInstance.updateUser(updateUser, success: { [weak self] (response) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            _self.delegate?.didClickBack()
        }) { [weak self] (error, errorDictionary) in
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
        guard let firstName = firstNameTextField.textField.text else {
            return
        }
        let firstNameValid = Validator.isValidText(firstName)
        
        guard let lastName = lastNameTextField.textField.text else {
            return
        }
        let lastNameValid = Validator.isValidText(lastName)
        
        if firstNameValid && lastNameValid {
            enableButton(nextButton)
        } else {
            disableButton(nextButton)
        }
    }
}
extension UserProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension UserProfileViewController : InputNavigationDelegate {
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
            let isLastItem = activeField == confirmPasswordTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == firstNameTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
