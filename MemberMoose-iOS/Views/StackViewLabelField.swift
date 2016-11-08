//
//  StackViewLabelView.swift
//  ShopperApp
//
//  Created by James Rhodes on 9/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import SnapKit
import FontAwesome_swift

private let padding: CGFloat = 18
private let verticalPadding: CGFloat = 6
private let fieldHeight: CGFloat = 40

class StackViewLabelField: UIView {
    
    lazy var inputLabel: UILabel = {
        let _label = UILabel()
        _label.text = "Label"
        
        self.addSubview(_label)
        return _label
    }()
    lazy var valueLabel: UILabel = {
        let field = UILabel()
        
        self.addSubview(field)
        return field
    }()
    
    override func updateConstraints() {
        inputLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
        }
        valueLabel.snp.updateConstraints { (make) -> Void in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(inputLabel.snp.bottom).inset(verticalPadding)
            make.height.equalTo(fieldHeight)
            make.bottom.equalTo(self)
        }
        super.updateConstraints()
    }
    
    func configure(_ text: String?, label: String? = nil, tag: Int? = 0) {
        inputLabel.text = label?.uppercased() ?? ""
        inputLabel.font = UIFontTheme.Regular(.tiny)
        
        valueLabel.text = text ?? ""
        valueLabel.font = UIFontTheme.Regular(.default)
        
        if let tag = tag {
            valueLabel.tag = tag
        }
    }
}
