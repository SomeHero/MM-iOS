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
    func didClickNumber(_ number: Int)
    func didClickSend()
}
class CalculatorKeyPadView: UIView {
    weak var delegate: CalculatorKeyPadViewDelegate?
    
    lazy var sevenButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 7
        _button.setTitle("7", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var eightButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 8
        _button.setTitle("8", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var nineButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 9
        _button.setTitle("9", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var fourButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 4
        _button.setTitle("4", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var fiveButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 5
        _button.setTitle("5", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var sixButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 6
        _button.setTitle("6", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var oneButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 1
        _button.setTitle("1", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var twoButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 2
        _button.setTitle("2", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var threeButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 3
        _button.setTitle("3", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var sendButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.xLarge)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.sendClicked(_:)), for: .touchUpInside)
        _button.tag = 0
        _button.setTitle("SEND", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var zeroButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFontTheme.Light(.large)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.addTarget(self, action: #selector(CalculatorKeyPadView.numberClicked(_:)), for: .touchUpInside)
        _button.tag = 0
        _button.setTitle("0", for: UIControlState())
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var decimalButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24)
        _button.setTitleColor(UIColorTheme.KeyboardDigitColor, for: UIControlState())
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .highlighted)
        _button.backgroundColor = .white
        _button.setTitle(String.fontAwesomeIcon(name: .caretLeft), for: .normal)
        
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
        sevenButton.snp.updateConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(fourButton)
            make.width.equalTo(eightButton)
        }
        eightButton.snp.updateConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(sevenButton.snp.right).offset(1)
            make.height.equalTo(sevenButton)
            make.width.equalTo(nineButton)
        }
        nineButton.snp.updateConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(eightButton.snp.right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(eightButton)
        }
        fourButton.snp.updateConstraints { (make) in
            make.top.equalTo(sevenButton.snp.bottom).offset(1)
            make.left.equalTo(self)
            make.height.equalTo(oneButton)
            make.width.equalTo(fiveButton)
        }
        fiveButton.snp.updateConstraints { (make) in
            make.top.equalTo(eightButton.snp.bottom).offset(1)
            make.left.equalTo(fourButton.snp.right).offset(1)
            make.height.equalTo(fourButton)
            make.width.equalTo(sixButton)
        }
        sixButton.snp.updateConstraints { (make) in
            make.top.equalTo(nineButton.snp.bottom).offset(1)
            make.left.equalTo(fiveButton.snp.right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(fiveButton)
        }
        oneButton.snp.updateConstraints { (make) in
            make.top.equalTo(fourButton.snp.bottom).offset(1)
            make.left.equalTo(self)
            make.height.equalTo(sendButton)
            make.width.equalTo(twoButton)
        }
        twoButton.snp.updateConstraints { (make) in
            make.top.equalTo(fiveButton.snp.bottom).offset(1)
            make.left.equalTo(oneButton.snp.right).offset(1)
            make.height.equalTo(oneButton)
            make.width.equalTo(threeButton)
        }
        threeButton.snp.updateConstraints { (make) in
            make.top.equalTo(sixButton.snp.bottom).offset(1)
            make.left.equalTo(twoButton.snp.right).offset(1)
            make.right.equalTo(self)
            make.height.equalTo(twoButton)
        }
        sendButton.snp.updateConstraints { (make) in
            make.top.equalTo(oneButton.snp.bottom).offset(1)
            make.left.equalTo(self)
            make.width.equalTo(zeroButton)
            make.bottom.equalTo(self)
        }
        zeroButton.snp.updateConstraints { (make) in
            make.top.equalTo(twoButton.snp.bottom).offset(1)
            make.left.equalTo(sendButton.snp.right).offset(1)
            make.bottom.equalTo(self)
        }
        decimalButton.snp.updateConstraints { (make) in
            make.top.equalTo(threeButton.snp.bottom).offset(1)
            make.left.equalTo(zeroButton.snp.right).offset(1)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(threeButton)
        }
        
        super.updateConstraints()
    }
    func numberClicked(_ sender: UIButton) {
        delegate?.didClickNumber(sender.tag)
    }
    func sendClicked(_ sender: UIButton) {
        delegate?.didClickSend()
    }
}
