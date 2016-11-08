//
//  PaymentHistoryEmptyState.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PaymentHistoryEmptyStateCell: UITableViewCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .left
        _label.font = UIFontTheme.Regular(.small)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
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
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? PaymentHistoryEmptyStateViewModel else {
            return
        }
        headerLabel.text = viewModel.header
    }
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(contentView).inset(40)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        headerLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
        }
        
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
