//
//  MenuItemHeaderCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol MenuHeaderDelegate: class {
    func didEditProfile()
}
class MenuHeaderCell: UITableViewCell {
    weak var delegate: MenuHeaderDelegate?
    
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Edit-Grey"), forState: .Normal)
        _button.addTarget(self, action: #selector(MenuHeaderCell.editProfileClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50 / 2
        imageView.clipsToBounds = true
        
        self.containerView.addSubview(imageView)
        
        return imageView
    }()
    private lazy var innerContainerView: UIView = {
        let _view = UIView()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    private lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.innerContainerView.addSubview(_label)
        
        return _label
    }()
    private lazy var emailLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.XTiny)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.innerContainerView.addSubview(_label)
        
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
            make.height.width.equalTo(50)
        }
        innerContainerView.snp_updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp_trailing).offset(10)
            make.top.bottom.equalTo(containerView).inset(20)
        }
        nameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(innerContainerView)
            make.top.equalTo(innerContainerView)
        }
        emailLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(innerContainerView)
            make.top.equalTo(nameLabel.snp_bottom)
            make.bottom.equalTo(innerContainerView)
        }
        settingsButton.snp_updateConstraints { (make) in
            make.leading.equalTo(innerContainerView.snp_trailing).offset(10)
            make.trailing.equalTo(containerView).inset(10)
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(20)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MenuHeaderViewModel {
            if let avatarImageUrl = viewModel.avatarUrl {
                avatarView.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                                           placeholderImage: UIImage(named: viewModel.avatar))
            } else {
                avatarView.image = UIImage(named: viewModel.avatar)
            }
            if let name = viewModel.name {
                nameLabel.hidden = false
                nameLabel.text = name
            } else {
                nameLabel.hidden = true
            }
            emailLabel.text = viewModel.emailAddress
            delegate = viewModel.menuHeaderDelegate
        }
    }
    func editProfileClicked(sender: UIButton) {
        delegate?.didEditProfile()
    }
}
