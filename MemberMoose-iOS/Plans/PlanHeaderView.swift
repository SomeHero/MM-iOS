//
//  PlanHeaderView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular()
        
        self.addSubview(_label)
        
        return _label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(title: String) {
        titleLabel.text = title
    }
}