//
//  PlanSubscriberCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//


import UIKit

class PlanSubscriberCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60 / 2
        imageView.clipsToBounds = true
        
        self.addSubview(imageView)
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.Small)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var emailAddressLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var memberSinceLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.containerView.addSubview(_label)
        
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
    func setupWith(viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? PlanSubscriberViewModel else {
            return
        }
        if let avatarImageUrl = viewModel.avatarUrl {
            avatarView.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                          placeholderImage: UIImage(named: viewModel.avatar))
        } else {
            avatarView.image = UIImage(named: viewModel.avatar)
        }
        if let name = viewModel.memberName {
            nameLabel.hidden = false
            nameLabel.text = name
        } else {
            nameLabel.hidden = true
        }
        memberSinceLabel.text = "Member Since 11/5/2015"
        planNameLabel.text = viewModel.planName
    }
    override func updateConstraints() {
        avatarView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(60)
        }
        containerView.snp_updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp_trailing).offset(10)
            make.trailing.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        nameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView).inset(10)
        }
        emailAddressLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(nameLabel.snp_bottom)
        }
        memberSinceLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(emailAddressLabel.snp_bottom)
        }
        planNameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(memberSinceLabel.snp_bottom)
            make.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}
