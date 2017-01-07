//
//  PlanActivityCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanActivityCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var activityLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
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
            make.leading.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(20)
        }
        activityLabel.snp.updateConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(containerView)
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
        if let viewModel = viewModel as? PlanActivityViewModel {
            activityLabel.text = viewModel.activity
            TextDecorator.applyTightLineHeight(toLabel: activityLabel)
        }
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
}
