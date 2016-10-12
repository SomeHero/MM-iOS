//
//  PlanCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {
    
    private lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    private lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    private lazy var subscribersCountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .DisclosureIndicator
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(viewModel: PlanViewModel) {
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = "$150.00/monthly"
        subscribersCountLabel.text = "\(viewModel.subscribersCount) Subscribers"
    }
    override func updateConstraints() {
        planNameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(10)
        }
        planAmountLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(planNameLabel.snp_bottom)
        }
        subscribersCountLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(planAmountLabel.snp_bottom)
            make.bottom.equalTo(contentView).inset(10)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}
