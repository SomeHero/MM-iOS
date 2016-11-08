//
//  StackViewTextField.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SnapKit
import FontAwesome_swift
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


private let padding: CGFloat = 18
private let verticalPadding: CGFloat = 6
private let fieldHeight: CGFloat = 40

class StackViewInputField: UIView {
    lazy var inputLabel: UILabel = {
        let _label = UILabel()
        
        self.addSubview(_label)
        return _label
    }()
    lazy var textField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        self.addSubview(field)
        return field
    }()
    fileprivate lazy var checkIcon: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage.fontAwesomeIcon(code: FontAwesome.check.rawValue, textColor: UIColor.flatBlue(), size: CGSize.init(width: 20, height: 20), backgroundColor: .clear)
        _imageView.alpha = 0
        
        self.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var underline: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.flatGray()
        self.addSubview(line)
        return line
    }()
    
    override func updateConstraints() {
        let labelHeight = (inputLabel.text?.characters.count > 0 ? fieldHeight : 0)
        inputLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).inset(verticalPadding)
            make.height.equalTo(labelHeight)
        }
        textField.snp.updateConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.top.equalTo(inputLabel.snp.bottom).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
        }
        checkIcon.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(padding)
            make.height.width.equalTo(20)
            make.leading.equalTo(textField.snp.trailing).offset(10)
            make.bottom.equalTo(underline.snp.top).offset(-6)
        }
        underline.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(textField.snp.bottom).inset(2)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        super.updateConstraints()
    }
    
    func addIconOnRight(_ icon: FontAwesome) {
        //textField.addIconOnRight(icon)
    }
    
    func addIconOnLeft(_ icon: FontAwesome) {
        //textField.addIconOnLeft(icon)
    }
    
    //func addIconOnLeftWithSize(icon: FontAwesome, sizeFontSize) {
    //textField.addIconOnLeftWithSize(icon, size: size)
    //}
    func configure(_ text: String?, label: String? = nil, placeholder: String? = nil, tag: Int? = 0, keyboardType: UIKeyboardType? = .default) {
        if let placeholder = placeholder {
            textField.placeholder = placeholder
        }
        inputLabel.text = label?.uppercased() ?? ""
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
    func isValid(_ valid: Bool) {
        if valid {
            checkIcon.alpha = 1
        } else {
            checkIcon.alpha = 0
        }
    }
}

