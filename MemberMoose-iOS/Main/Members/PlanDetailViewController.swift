//
//  PlanDetailViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        
        input.textField.addTarget(self, action: #selector(PlanDetailViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var planDescriptionView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Description of Plan (Optional)", placeholder: "Enter a Description", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PlanDetailViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var paymentTypeView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "How do you want to charge customers?", placeholder: "ONE-TIME OR RECURRING", tag: 103)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PlanDetailViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var amountView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Amount", placeholder: "Amount to Charge", tag: 104)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PlanDetailViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(PlanDetailViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(_button)
        
        return _button
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
        guard let planName = planNameView.textField.text, planDescription = planDescriptionView.textField.text, paymentType = paymentTypeView.textField.text, amountText = amountView.textField.text, amount = Double(amountText) else {
            return
        }
        let createPlan = CreatePlan(name: planName, amount: amount, interval: "month", intervalCount: 1, statementDescriptor: "", trialPeriodDays: 0, statementDescription: "")
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.createPlan(createPlan, success: { [weak self] (response) in
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
