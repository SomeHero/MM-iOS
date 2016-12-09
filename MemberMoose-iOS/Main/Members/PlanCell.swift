//
//  PlanCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60 / 2
        imageView.clipsToBounds = true
        
        self.contentView.addSubview(imageView)
        
        return imageView
    }()
    fileprivate lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.SemiBold(.large)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subscribersCountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.PrimaryFont
        
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
        if let avatarImageUrl = viewModel.avatarUrl {
            avatarView.kf.setImage(with: URL(string: avatarImageUrl)!,
                                   placeholder: UIImage(named: viewModel.avatar))
        } else {
            avatarView.image = UIImage(named: viewModel.avatar)
        }
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = viewModel.planAmount
        subscribersCountLabel.text = viewModel.subscribersCount
    }
    override func updateConstraints() {
        avatarView.snp.updateConstraints { (make) -> Void in
            make.leading.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(60)
        }
        containerView.snp.updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        planNameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView).inset(10)
            make.top.equalTo(containerView).inset(10)
        }
        planAmountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView).inset(10)
            make.top.equalTo(planNameLabel.snp.bottom)
        }
        subscribersCountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView).inset(10)
            make.top.equalTo(planAmountLabel.snp.bottom)
            make.bottom.equalTo(containerView).inset(10)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
