//
//  MemberCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell, DataSourceItemCell {

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
    fileprivate lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.small)
        _label.textColor = UIColor.flatBlack()
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var emailAddressLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var memberSinceLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.containerView.addSubview(_label)
        
        return _label
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
        guard let viewModel = viewModel as? MemberViewModel else {
            return
        }
        if let avatarImageUrl = viewModel.avatarUrl {
            avatarView.kf.setImage(with: URL(string: avatarImageUrl)!,
                                          placeholder: UIImage(named: viewModel.avatar))
        } else {
            avatarView.image = UIImage(named: viewModel.avatar)
        }
        if let name = viewModel.memberName {
            nameLabel.isHidden = false
            nameLabel.text = name
        } else {
            nameLabel.isHidden = true
        }
        memberSinceLabel.text = "Member Since 11/5/2015"
        planNameLabel.text = viewModel.planName
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
        nameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView).inset(10)
        }
        emailAddressLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        memberSinceLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(emailAddressLabel.snp.bottom)
        }
        planNameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(memberSinceLabel.snp.bottom)
            make.bottom.equalTo(containerView)
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
}
