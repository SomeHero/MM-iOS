//
//  OneTimePaymentViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class OneTimePaymentViewController: UIViewController {

    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), for: UIControlState())
        _button.addTarget(self, action: #selector(OneTimePaymentViewController.toggleMenu(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var amountTextField: UITextField = {
        let _textField = UITextField()
        _textField.backgroundColor = .clear
        _textField.clearButtonMode = .never
        _textField.textAlignment = .right
        _textField.textColor = .white
        _textField.font = UIFontTheme.Regular(.huge)
        
        self.containerView.addSubview(_textField)
        return _textField
    }()
    fileprivate lazy var calculatorKeyboard: CalculatorKeyboard = {
        let _calculatorKeyboard = CalculatorKeyboard(frame: CGRect.zero)
        _calculatorKeyboard.delegate = self
        self.amountTextField.inputView = _calculatorKeyboard
        
        self.view.addSubview(_calculatorKeyboard)
        
        return _calculatorKeyboard
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
        
        topBackgroundView.snp.updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        containerView.snp.updateConstraints { (make) in
            make.centerX.centerY.equalTo(topBackgroundView)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
        }
        amountTextField.snp.updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        calculatorKeyboard.snp.updateConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp.bottom)
            make.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
        }

    }
    func setup() {
        subHeadingLabel.text = "One Time Payments"
        amountTextField.text = "$0.00"
    }
}
extension OneTimePaymentViewController: CalculatorDelegate {
    func calculator(_ calculator: CalculatorKeyboard, didChangeValue value: String) {
        amountTextField.text = value
    }
    func didContinue(_ calculator: CalculatorKeyboard) {
        if let text = amountTextField.text, let value = Double(text) {
            //calculatorOverlayDelegate?.didContinue(value)
        }
    }
}
