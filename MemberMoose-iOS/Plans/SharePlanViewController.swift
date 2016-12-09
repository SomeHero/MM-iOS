//
//  SharePlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SharePlanViewController: UIViewController {
    var activeField: UITextField?
    fileprivate let plan: Plan

    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailAddressTextField, self.phoneNumberTextField])
        stack.axis = .vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var emailAddressTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "EMAIL ADDRESS", tag: 101)
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(SharePlanViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var phoneNumberTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "PHONE NUMBER", tag: 102)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        self.configureTextField(_textField.textField)
        
        _textField.textField.addTarget(self, action: #selector(SharePlanViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(SharePlanViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    
    init(plan: Plan) {
        self.plan = plan
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Share Plan"
        
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView).offset(60)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView)
        }
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        textField.delegate = self
        
        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        })
    }
    func validateForm() {
        guard let emailAddress = emailAddressTextField.textField.text else {
            return
        }
        let emailAddressValid = Validator.isValidEmail(emailAddress)
        
        guard let phoneNumber = phoneNumberTextField.textField.text else {
            return
        }
        let phoneNumberValid = Validator.isValidText(phoneNumber)
        
        if emailAddressValid && phoneNumberValid {
            enableButton(nextButton)
        } else {
            disableButton(nextButton)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func nextClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension SharePlanViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension SharePlanViewController : InputNavigationDelegate {
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
            let isLastItem = activeField == phoneNumberTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == emailAddressTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
