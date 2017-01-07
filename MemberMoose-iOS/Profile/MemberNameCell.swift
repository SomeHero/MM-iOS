//
//  MemberNameTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MemberNameCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var editButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 18)
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .normal)
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: .highlighted)
        _button.setTitle(String.fontAwesomeIcon(name: .pencil), for: .normal)
        _button.backgroundColor = UIColor.clear
        _button.isUserInteractionEnabled = false
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = .flatWhite()
        
        self.addSubview(_lineView)
        
        return _lineView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        selectionStyle = .none
        contentMode = .redraw
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        nameLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }
        editButton.snp.updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing)
            make.trailing.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(kOnePX*2)
            make.bottom.equalTo(self)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MemberNameViewModel {
            if let name = viewModel.name {
                nameLabel.text = name
            } else {
                nameLabel.text = "Add Member Name"
            }
            TextDecorator.applyTightLineHeight(toLabel: nameLabel)
        }
    }
}

