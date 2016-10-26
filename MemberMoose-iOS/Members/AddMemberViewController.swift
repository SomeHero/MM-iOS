//
//  AddMemberViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddMemberViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.view.addSubview(_scrollView)
        
        return _scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.firstNameView, self.lastNameView, self.emailAddressView])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var firstNameView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "First Name", placeholder: "Enter Member's First Name", tag: 100)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var lastNameView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Last Name", placeholder: "Enter Member's Last Name", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var emailAddressView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Email Address", placeholder: "Enter Member's Email Address", tag: 103)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(AddMemberViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        title = "Add Member"
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackView.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.width).inset(20*2)
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(stackView.snp_bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
        }
        
        super.viewDidLayoutSubviews()
    }
    func setup() {
        
    }
    func validateForm() {
        
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
        //textField.delegate = self
        
        //let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //textField.inputAccessoryView = toolBar
    }
    func resetScrollViewInsets() {
        UIView.animateWithDuration(0.2) {
            let contentInsets = UIEdgeInsetsZero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func nextClicked(sender: UIButton) {
        guard let firstName = firstNameView.textField.text, lastName = lastNameView.textField.text, emailAddress = emailAddressView.textField.text else {
            return
        }
        let createMember = CreateMember(firstName: firstName, lastName: lastName, emailAddress: emailAddress)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.createMember(createMember, success: { [weak self] (response) in
            guard let _self = self else {
                return
            }
            SVProgressHUD.dismiss()
            
            _self.navigationController?.popViewControllerAnimated(true)
        }) { (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            print("error occurred")
        }
    }
}
