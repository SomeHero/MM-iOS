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
    fileprivate lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.view.addSubview(_scrollView)
        
        return _scrollView
    }()
    fileprivate lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.firstNameView, self.lastNameView, self.emailAddressView])
        stack.axis = .vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var firstNameView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "First Name", placeholder: "Enter Member's First Name", tag: 100)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    fileprivate lazy var lastNameView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Last Name", placeholder: "Enter Member's Last Name", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    fileprivate lazy var emailAddressView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Email Address", placeholder: "Enter Member's Email Address", tag: 103)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(AddMemberViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(AddMemberViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        title = "Add Member"
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackView.snp.updateConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width).inset(20*2)
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(40)
        }
        
        super.viewDidLayoutSubviews()
    }
    func setup() {
        
    }
    func validateForm() {
        
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        //textField.delegate = self
        
        //let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //textField.inputAccessoryView = toolBar
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }) 
    }
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    func nextClicked(_ sender: UIButton) {
        guard let firstName = firstNameView.textField.text, let lastName = lastNameView.textField.text, let emailAddress = emailAddressView.textField.text else {
            return
        }
        let createMember = CreateMember(firstName: firstName, lastName: lastName, emailAddress: emailAddress)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.createMember(createMember, success: { [weak self] (response) in
            guard let _self = self else {
                return
            }
            SVProgressHUD.dismiss()
            
            let _ = _self.navigationController?.popViewController(animated: true)
        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
}
