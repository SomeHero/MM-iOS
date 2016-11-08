//
//  PlanCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {
    
    fileprivate lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        _label.numberOfLines = 0
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subscribersCountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    lazy var currencyFormatter: NumberFormatter = {
        let _formatter = NumberFormatter()
        _formatter.generatesDecimalNumbers = true
        _formatter.numberStyle = .currency
        
        return _formatter
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .disclosureIndicator
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? PlanViewModel else {
            return
        }
        
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = viewModel.planAmount
        subscribersCountLabel.text = "\(viewModel.subscribersCount) Subscribers"
    }
    override func updateConstraints() {
        planNameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(10)
        }
        planAmountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(planNameLabel.snp.bottom)
        }
        subscribersCountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(planAmountLabel.snp.bottom)
            make.bottom.equalTo(contentView).inset(10)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
