//
//  SubscribeViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SubscribeViewController: UIViewController {
    fileprivate enum Copy: String {
        case TitleText = "Send Subscription Link"
    }
    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu-Reverse"), for: UIControlState())
        _button.addTarget(self, action: #selector(SubscribeViewController.toggleMenu(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.font = UIFontTheme.Regular(.default)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        
        self.view.addSubview(_scrollView)
        return _scrollView
    }()
    fileprivate lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailTextField])
        stack.axis = .vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var emailTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", label: "Email", placeholder: "Email Address", tag: 102)
        self.configureTextField(_textField.textField)
        
        //        _textField.textField.addTarget(self, action: #selector(ConfirmFacebookAccountViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return _textField
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

        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.greaterThanOrEqualTo(menuButton.snp.trailing).inset(10)
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
        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(60)
            make.leading.trailing.equalTo(view).inset(20)
        }
    }
    fileprivate func setup() {
        titleLabel.text = Copy.TitleText.rawValue
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        //        textField.delegate = self
        //
        //        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        //        textField.inputAccessoryView = toolBar
    }
}
