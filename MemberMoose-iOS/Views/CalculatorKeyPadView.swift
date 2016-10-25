//
//  CalculatorKeyPadView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//
import Foundation
import FontAwesome_swift

protocol CalculatorKeyPadViewDelegate: class {
    func didClickNumber(number: Int)
}
class CalculatorKeyPadView: UIView {
    weak var delegate: CalculatorKeyPadViewDelegate?
    
    lazy var sevenButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 7
        _button.setTitle("7", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var eightButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 8
        _button.setTitle("8", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var nineButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 9
        _button.setTitle("9", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var fourButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 4
        _button.setTitle("4", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var fiveButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 5
        _button.setTitle("5", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var sixButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 6
        _button.setTitle("6", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var oneButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 1
        _button.setTitle("1", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var twoButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 2
        _button.setTitle("2", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var threeButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 3
        _button.setTitle("3", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var zeroButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.XLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.tag = 0
        _button.setTitle("0", forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var decimalButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, forState: .Normal)
        _button.setTitleColor(UIColorTheme.PrimaryFont, forState: .Highlighted)
        _button.backgroundColor = .whiteColor()
        _button.setTitle(String.fontAwesomeIconWithName(FontAwesome.CaretLeft), forState: .Normal)
        
        self.addSubview(_button)
        
        return _button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColorTheme.NavBarLineView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateConstraints() {
        sevenButton.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(fourButton)
            make.width.equalTo(eightButton)
        }
        eightButton.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(sevenButton.snp_right).offset(1)
            make.height.equalTo(sevenButton)
            make.width.equalTo(nineButton)
        }
        nineButton.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(eightButton.snp_right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(eightButton)
        }
        fourButton.snp_makeConstraints { (make) in
            make.top.equalTo(sevenButton.snp_bottom).offset(1)
            make.left.equalTo(self)
            make.height.equalTo(oneButton)
            make.width.equalTo(fiveButton)
        }
        fiveButton.snp_makeConstraints { (make) in
            make.top.equalTo(eightButton.snp_bottom).offset(1)
            make.left.equalTo(fourButton.snp_right).offset(1)
            make.height.equalTo(fourButton)
            make.width.equalTo(sixButton)
        }
        sixButton.snp_makeConstraints { (make) in
            make.top.equalTo(nineButton.snp_bottom).offset(1)
            make.left.equalTo(fiveButton.snp_right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(fiveButton)
        }
        oneButton.snp_makeConstraints { (make) in
            make.top.equalTo(fourButton.snp_bottom).offset(1)
            make.left.equalTo(self)
            make.height.equalTo(zeroButton)
            make.width.equalTo(twoButton)
        }
        twoButton.snp_makeConstraints { (make) in
            make.top.equalTo(fiveButton.snp_bottom).offset(1)
            make.left.equalTo(oneButton.snp_right).offset(1)
            make.height.equalTo(oneButton)
            make.width.equalTo(threeButton)
        }
        threeButton.snp_makeConstraints { (make) in
            make.top.equalTo(sixButton.snp_bottom).offset(1)
            make.left.equalTo(twoButton.snp_right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(twoButton)
        }
        zeroButton.snp_makeConstraints { (make) in
            make.top.equalTo(twoButton.snp_bottom).offset(1)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        decimalButton.snp_makeConstraints { (make) in
            make.top.equalTo(threeButton.snp_bottom).offset(1)
            make.left.equalTo(zeroButton.snp_right).offset(1)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(threeButton)
        }
        
        super.updateConstraints()
    }
    func numberClicked(sender: UIButton) {
        delegate?.didClickNumber(sender.tag)
    }
}
