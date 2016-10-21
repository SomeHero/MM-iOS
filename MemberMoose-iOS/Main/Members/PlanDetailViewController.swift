//
//  PlanDetailViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanDetailViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.view.addSubview(_scrollView)
        
        return _scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.planNameView, self.planDescriptionView, self.paymentTypeView, self.amountView])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var planNameView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Plan Name", placeholder: "Enter Name of Plan", tag: 100)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var planDescriptionView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Description of Plan (Optional)", placeholder: "Enter a Description", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var paymentTypeView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "How do you want to charge customers?", placeholder: "ONE-TIME OR RECURRING", tag: 103)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var amountView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Amount", placeholder: "Amount to Charge", tag: 104)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        
        title = "Plan Detail"
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
        
        super.viewDidLayoutSubviews()
    }
    func setup() {
        
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
}
