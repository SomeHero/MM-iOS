//
//  StackViewTextField.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import SnapKit
import FontAwesome_swift

private let padding: CGFloat = 18
private let verticalPadding: CGFloat = 6
private let fieldHeight: CGFloat = 40

class StackViewInputField: UIView {
//    lazy var inputLabel: UILabel = {
//        let _label = UILabel()
//        _label.font = UIFontTheme.Regular(.Tiny)
//        
//        self.addSubview(_label)
//        return _label
//    }()
    lazy var textField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .WhileEditing
        
        self.addSubview(field)
        return field
    }()
    private lazy var checkIcon: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage.fontAwesomeIconWithName(FontAwesome.Check, textColor: UIColor.flatBlueColor(), size: CGSize.init(width: 20, height: 20), backgroundColor: UIColor.clearColor())
        _imageView.alpha = 0
        
        self.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var underline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.flatGrayColor()
        self.addSubview(line)
        return line
    }()
    
    override func updateConstraints() {
        textField.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.top.equalTo(self).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
        }
        checkIcon.snp_updateConstraints { (make) in
            make.trailing.equalTo(self).inset(padding)
            make.height.width.equalTo(20)
            make.leading.equalTo(textField.snp_trailing).offset(10)
            make.bottom.equalTo(underline.snp_top).offset(-6)
        }
        underline.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(textField.snp_bottom).inset(2)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        super.updateConstraints()
    }
    
    func addIconOnRight(icon: FontAwesome) {
        //textField.addIconOnRight(icon)
    }
    
    func addIconOnLeft(icon: FontAwesome) {
        //textField.addIconOnLeft(icon)
    }
    
    //func addIconOnLeftWithSize(icon: FontAwesome, sizeFontSize) {
    //textField.addIconOnLeftWithSize(icon, size: size)
    //}
    
    func configure(text: String?, label: String? = nil, placeholder: String? = nil, tag: Int? = 0, keyboardType: UIKeyboardType? = .Default) {
        if let placeholder = placeholder {
            textField.placeholder = placeholder.uppercaseString
        }
        textField.text = text ?? ""
        
        if let tag = tag {
            textField.tag = tag
        }
        
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        }
    }
    func wwtextfieldDidStartEditing() {
        textField.becomeFirstResponder()
    }
    func isValid(valid: Bool) {
        if valid {
            checkIcon.alpha = 1
        } else {
            checkIcon.alpha = 0
        }
    }
}
