//
//  CreatePlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController {
    private lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "Back"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(CreatePlanViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        
        self.view.addSubview(_scrollView)
        return _scrollView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.planNameTextField, self.planDescriptionTextField, self.planChargeTypeTextField, self.planAmount, self.recurringPeriod, self.recurringDuration])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var planNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Plan Name", placeholder: "My Subscription Plan", tag: 101)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var planDescriptionTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Plan Description (Optional)", placeholder: "", tag: 102)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    private lazy var planChargeTypeTextField: PlanChargeTypeInputField = {
        let _textField = PlanChargeTypeInputField()
        _textField.configure("How do you want to charge customers?")
        _textField.planChargeTypeDelegate = self
        return _textField
    }()
    private lazy var planAmount: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Amount", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.hidden = true
        return _textField
    }()
    private lazy var recurringPeriod: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Recurring Period", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.hidden = true
        return _textField
    }()
    private lazy var recurringDuration: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Recurring Duration", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.hidden = true
        return _textField
    }()
    private lazy var nextButton: UIButton = {
       let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setImage(UIImage(named: "RightArrow-Reversed"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        self.view.addSubview(_button)
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        titleLabel.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.greaterThanOrEqualTo(backButton.snp_trailing).inset(10)
            //make.trailing.equalTo(leading)
            make.centerX.equalTo(view)
        }
        scrollView.snp_updateConstraints { (make) in
            make.top.equalTo(titleLabel).inset(10)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view).inset(60)
        }
        stackView.snp_updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(scrollView.snp_bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        nextButton.imageView?.snp_updateConstraints(closure: { (make) in
            make.height.equalTo(40)
        })
    }
    func setup() {
        titleLabel.text = "Create First Plan"
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
        //        textField.delegate = self
        //
        //        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //        textField.inputAccessoryView = toolBar
    }
}
extension CreatePlanViewController: PlanChargeTypeDelegate {
    func didSetOneTime() {
        planAmount.hidden = false
        recurringPeriod.hidden = true
        recurringDuration.hidden = true
    }
    func didSetRecurrion() {
        planAmount.hidden = false
        recurringPeriod.hidden = false
        recurringDuration.hidden = false
    }
}
protocol PlanChargeTypeDelegate: class {
    func didSetOneTime()
    func didSetRecurrion()
}
class PlanChargeTypeInputField: UIView {
    private let padding: CGFloat = 18
    private let verticalPadding: CGFloat = 6
    private let fieldHeight: CGFloat = 40

    weak var planChargeTypeDelegate: PlanChargeTypeDelegate?
    
    lazy var inputLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.addSubview(_label)
        return _label
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.oneTimeCheckbox, self.recurringCheckbox])
        stack.axis = .Horizontal
        stack.spacing = 10
        stack.distribution = .FillProportionally
        
        self.addSubview(stack)
        
        return stack
    }()
    lazy var oneTimeCheckbox: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColor.clearColor()
        _button.layer.cornerRadius = 5
        _button.layer.borderWidth = 1.0
        _button.layer.masksToBounds = true
        _button.layer.backgroundColor = UIColor.clearColor().CGColor
        _button.setTitle("One Time", forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Normal)
        
        _button.addTarget(self, action: #selector(PlanChargeTypeInputField.oneTimeClicked(_:)), forControlEvents: .TouchUpInside)
        return _button
    }()
    lazy var recurringCheckbox: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColor.clearColor()
        _button.layer.cornerRadius = 5
        _button.layer.borderWidth = 1.0
        _button.layer.masksToBounds = true
        _button.layer.backgroundColor = UIColor.clearColor().CGColor
        _button.setTitle("Recurring", forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Normal)
        
        _button.addTarget(self, action: #selector(PlanChargeTypeInputField.recurringClicked(_:)), forControlEvents: .TouchUpInside)
        return _button
    }()
    override func updateConstraints() {
        inputLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
        }
        stackView.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(inputLabel.snp_bottom).inset(verticalPadding)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    func configure(label: String? = nil, placeholder: String? = nil, tag: Int? = 0, keyboardType: UIKeyboardType? = .Default) {
        inputLabel.text = label?.uppercaseString ?? ""
 
    }
    func oneTimeClicked(sender: UIButton) {
        planChargeTypeDelegate?.didSetOneTime()
    }
    func recurringClicked(sender: UIButton) {
        planChargeTypeDelegate?.didSetRecurrion()
    }
}
