//
//  OneTimePaymentViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class OneTimePaymentViewController: UIViewController {

    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), forState: .Normal)
        _button.addTarget(self, action: #selector(OneTimePaymentViewController.toggleMenu(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var amountTextField: UITextField = {
        let _textField = UITextField()
        _textField.backgroundColor = .clearColor()
        _textField.clearButtonMode = .Never
        _textField.textAlignment = .Right
        _textField.textColor = .whiteColor()
        _textField.font = UIFontTheme.Regular(.Huge)
        
        self.containerView.addSubview(_textField)
        return _textField
    }()
    private lazy var calculatorKeyboard: CalculatorKeyboard = {
        let _calculatorKeyboard = CalculatorKeyboard(frame: CGRect.zero)
        _calculatorKeyboard.delegate = self
        self.amountTextField.inputView = _calculatorKeyboard
        
        self.view.addSubview(_calculatorKeyboard)
        
        return _calculatorKeyboard
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
        
        topBackgroundView.snp_updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        containerView.snp_updateConstraints { (make) in
            make.centerX.centerY.equalTo(topBackgroundView)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
        }
        amountTextField.snp_updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp_bottom)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        calculatorKeyboard.snp_updateConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp_bottom)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
            make.leading.trailing.equalTo(view)
        }

    }
    func toggleMenu(sender: UIButton) {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate, swRevealViewController = delegate.swRevealViewController {
            swRevealViewController.revealToggleAnimated(true)
        }
    }
    func setup() {
        subHeadingLabel.text = "One Time Payments"
        amountTextField.text = "$0.00"
    }
}
extension OneTimePaymentViewController: CalculatorDelegate {
    func calculator(calculator: CalculatorKeyboard, didChangeValue value: String) {
        amountTextField.text = value
    }
    func didContinue(calculator: CalculatorKeyboard) {
        if let text = amountTextField.text, value = Double(text) {
            //calculatorOverlayDelegate?.didContinue(value)
        }
    }
}
