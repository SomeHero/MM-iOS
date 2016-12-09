//
//  MessageCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/17/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, DataSourceItemProtocol {
    static let identifier = "MessageCellIdentifier"
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50 / 2
        imageView.clipsToBounds = true
        
        self.addSubview(imageView)
        
        return imageView
    }()
    fileprivate lazy var authorLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.tiny)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 1
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var messageSentLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.tiny)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var contentLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
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
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(_ viewModel: MessageViewModel) {
        avatarView.image = UIImage(named: "Avatar-Calf")
        contentLabel.text = viewModel.content
        authorLabel.text = viewModel.authorName
        messageSentLabel.text = viewModel.messageSent
    }
    override func updateConstraints() {
        avatarView.snp.updateConstraints { (make) -> Void in
            make.leading.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(50)
        }
        containerView.snp.updateConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        authorLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        messageSentLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(authorLabel.snp.trailing).offset(5)
            make.top.equalTo(containerView)
            make.trailing.greaterThanOrEqualTo(containerView)
            make.bottom.equalTo(contentLabel.snp.top)
        }
        contentLabel.snp.updateConstraints { (make) in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(10)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}

