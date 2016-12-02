//
//  PlanAmountCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

class PlanAmountCell: UITableViewCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var amountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
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
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        amountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }
        
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanAmountViewModel {
            if let amount = viewModel.amount, let interval = viewModel.interval {
                amountLabel.text = "\(USD(amount).description)/\(interval)"
            } else {
                amountLabel.text = "Set Recurring Amount"
            }
            TextDecorator.applyTightLineHeight(toLabel: amountLabel)
        }
    }

}
