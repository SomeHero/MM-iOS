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
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Edit-Grey"), for: UIControlState())
        _button.addTarget(self, action: #selector(MenuHeaderCell.editProfileClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50 / 2
        imageView.clipsToBounds = true
        
        self.containerView.addSubview(imageView)
        
        return imageView
    }()
    fileprivate lazy var innerContainerView: UIView = {
        let _view = UIView()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.innerContainerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var emailLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.xTiny)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.innerContainerView.addSubview(_label)
        
        return _label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        
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
        avatarView.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(50)
        }
        innerContainerView.snp.updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.top.bottom.equalTo(containerView).inset(20)
        }
        nameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(innerContainerView)
            make.top.equalTo(innerContainerView)
        }
        emailLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(innerContainerView)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(innerContainerView)
        }
        settingsButton.snp.updateConstraints { (make) in
            make.leading.equalTo(innerContainerView.snp.trailing).offset(10)
            make.trailing.equalTo(containerView).inset(10)
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(20)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MenuHeaderViewModel {
            if let avatarImageUrl = viewModel.avatarUrl {
                avatarView.kf.setImage(with: URL(string: avatarImageUrl)!,
                                                           placeholder: UIImage(named: viewModel.avatar))
            } else {
                avatarView.image = UIImage(named: viewModel.avatar)
            }
            if let name = viewModel.name {
                nameLabel.isHidden = false
                nameLabel.text = name
            } else {
                nameLabel.isHidden = true
            }
            emailLabel.text = viewModel.emailAddress
            delegate = viewModel.menuHeaderDelegate
        }
    }
    func editProfileClicked(_ sender: UIButton) {
        delegate?.didEditProfile()
    }
}
