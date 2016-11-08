//
//  CreatePlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController {
    fileprivate lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "Back"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(CreatePlanViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        
        self.view.addSubview(_scrollView)
        return _scrollView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.planNameTextField, self.planDescriptionTextField, self.planChargeTypeTextField, self.planAmount, self.recurringPeriod, self.recurringDuration])
        stack.axis = .vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var planNameTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Plan Name", placeholder: "My Subscription Plan", tag: 101)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    fileprivate lazy var planDescriptionTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Plan Description (Optional)", placeholder: "", tag: 102)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
    }()
    fileprivate lazy var planChargeTypeTextField: PlanChargeTypeInputField = {
        let _textField = PlanChargeTypeInputField()
        _textField.configure("How do you want to charge customers?")
        _textField.planChargeTypeDelegate = self
        return _textField
    }()
    fileprivate lazy var planAmount: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Amount", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.isHidden = true
        return _textField
    }()
    fileprivate lazy var recurringPeriod: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Recurring Period", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.isHidden = true
        return _textField
    }()
    fileprivate lazy var recurringDuration: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Recurring Duration", placeholder: "", tag: 104)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        _textField.isHidden = true
        return _textField
    }()
    fileprivate lazy var nextButton: UIButton = {
       let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setImage(UIImage(named: "RightArrow-Reversed"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        self.view.addSubview(_button)
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).inset(10)
            //make.trailing.equalTo(leading)
            make.centerX.equalTo(view)
        }
        scrollView.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel).inset(10)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view).inset(60)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        nextButton.imageView?.snp.updateConstraints({ (make) in
            make.height.equalTo(40)
        })
    }
    func setup() {
        titleLabel.text = "Create First Plan"
    }
    func backClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func nextClicked(_ sender: UIButton) {
        let viewController = CreateFirstPlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        //        textField.delegate = self
        //
        //        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //        textField.inputAccessoryView = toolBar
    }
}
extension CreatePlanViewController: PlanChargeTypeDelegate {
    func didSetOneTime() {
        planAmount.isHidden = false
        recurringPeriod.isHidden = true
        recurringDuration.isHidden = true
    }
    func didSetRecurrion() {
        planAmount.isHidden = false
        recurringPeriod.isHidden = false
        recurringDuration.isHidden = false
    }
}
protocol PlanChargeTypeDelegate: class {
    func didSetOneTime()
    func didSetRecurrion()
}
class PlanChargeTypeInputField: UIView {
    fileprivate let padding: CGFloat = 18
    fileprivate let verticalPadding: CGFloat = 6
    fileprivate let fieldHeight: CGFloat = 40

    weak var planChargeTypeDelegate: PlanChargeTypeDelegate?
    
    lazy var inputLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.addSubview(_label)
        return _label
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.oneTimeCheckbox, self.recurringCheckbox])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
        
        self.addSubview(stack)
        
        return stack
    }()
    lazy var oneTimeCheckbox: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColor.clear
        _button.layer.cornerRadius = 5
        _button.layer.borderWidth = 1.0
        _button.layer.masksToBounds = true
        _button.layer.backgroundColor = UIColor.clear.cgColor
        _button.setTitle("One Time", for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: UIControlState())
        
        _button.addTarget(self, action: #selector(PlanChargeTypeInputField.oneTimeClicked(_:)), for: .touchUpInside)
        return _button
    }()
    lazy var recurringCheckbox: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColor.clear
        _button.layer.cornerRadius = 5
        _button.layer.borderWidth = 1.0
        _button.layer.masksToBounds = true
        _button.layer.backgroundColor = UIColor.clear.cgColor
        _button.setTitle("Recurring", for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: UIControlState())
        
        _button.addTarget(self, action: #selector(PlanChargeTypeInputField.recurringClicked(_:)), for: .touchUpInside)
        return _button
    }()
    override func updateConstraints() {
        inputLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
        }
        stackView.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(inputLabel.snp.bottom).inset(verticalPadding)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    func configure(_ label: String? = nil, placeholder: String? = nil, tag: Int? = 0, keyboardType: UIKeyboardType? = .default) {
        inputLabel.text = label?.uppercased() ?? ""
 
    }
    func oneTimeClicked(_ sender: UIButton) {
        planChargeTypeDelegate?.didSetOneTime()
    }
    func recurringClicked(_ sender: UIButton) {
        planChargeTypeDelegate?.didSetRecurrion()
    }
}
