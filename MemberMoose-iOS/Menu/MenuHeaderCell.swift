//
//  MenuItemHeaderCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewCell {

    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60 / 2
        imageView.clipsToBounds = true
        
        self.containerView.addSubview(imageView)
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var emailLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.Tiny)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        avatarView.snp_updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(60)
        }
        nameLabel.snp_updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp_trailing).offset(20)
            make.trailing.equalTo(containerView)
            make.top.equalTo(containerView).inset(20)
        }
        emailLabel.snp_updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp_trailing).offset(20)
            make.trailing.equalTo(containerView)
            make.top.equalTo(nameLabel.snp_bottom)
            make.bottom.equalTo(containerView).inset(20)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MenuHeaderViewModel {
            avatarView.image = UIImage(named: viewModel.avatar)
            nameLabel.text = viewModel.name.uppercaseString
            emailLabel.text = viewModel.emailAddress
        }
    }
}
