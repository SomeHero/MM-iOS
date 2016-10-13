//
//  SubscribeViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SubscribeViewController: UIViewController {
    private enum Copy: String {
        case TitleText = "Send Subscription Link"
    }
    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu-Reverse"), forState: .Normal)
        _button.addTarget(self, action: #selector(SubscribeViewController.toggleMenu(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Default)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        
        self.view.addSubview(_scrollView)
        return _scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailTextField])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    private lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Email", placeholder: "Email Address", tag: 102)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
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

        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        titleLabel.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.greaterThanOrEqualTo(menuButton.snp_trailing).inset(10)
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
        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        titleLabel.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(60)
            make.leading.trailing.equalTo(view).inset(20)
        }
    }
    private func setup() {
        titleLabel.text = Copy.TitleText.rawValue
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
        //        textField.delegate = self
        //
        //        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //        textField.inputAccessoryView = toolBar
    }
}
