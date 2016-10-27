//
//  PlanProfileHeaderCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanProfileHeaderCell: UITableViewCell {
    private lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.whiteColor().CGColor
        _imageView.layer.borderWidth = 2.0
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var headingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .whiteColor()
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var planNavigation: PlanNavigationView = {
        let _view = PlanNavigationView()
        //_view.delegate = self
        self.contentView.addSubview(_view)
        
        return _view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColorTheme.TopBackgroundColor
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        selectionStyle = .None
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
        logo.snp_updateConstraints { (make) in
            make.top.equalTo(containerView).inset(20)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(headingLabel.snp_bottom)
            make.centerX.equalTo(containerView)
        }
        planNavigation.snp_updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanProfileHeaderViewModel {
            if let avatarImageUrl = viewModel.avatarImageUrl {
                logo.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                        placeholderImage: UIImage(named: viewModel.avatar))
            } else {
                logo.image = UIImage(named: viewModel.avatar)
            }
            headingLabel.text = viewModel.planName
            subHeadingLabel.text = viewModel.membersCount
            planNavigation.delegate = viewModel.planNavigationDelegate
            planNavigation.setSelectedButton(viewModel.planNavigationState)
            planNavigation.bringSubviewToFront(containerView)
            
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
}