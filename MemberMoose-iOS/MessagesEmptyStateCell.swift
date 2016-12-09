//
//  MessagesEmptyStateCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/17/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MessagesEmptyStateCell: UITableViewCell, DataSourceItemCell {
    static let identifier = "MessagesEmptyStateCellIdentifier"
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.containerView.addSubview(_view)
        
        return _view
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
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? MessagesEmptyStateViewModel else {
            return
        }
        logo.image = UIImage(named: viewModel.logo)
        headerLabel.text = viewModel.header
        subHeadingLabel.text = viewModel.subHeader
    }
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.center.equalTo(contentView)
            make.edges.equalTo(contentView).inset(20)
        }
        logo.snp.updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headerLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.trailing.equalTo(containerView).inset(40)
        }
        buttonContainer.snp.updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(20)
        }

        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
