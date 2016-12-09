//
//  CalfProfileHeaderView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/8/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class CalfProfileHeaderView: UICollectionReusableView {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.white.cgColor
        _imageView.layer.borderWidth = 2.0
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var headingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .white
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var memberNavigation: MemberNavigationView = {
        let _view = MemberNavigationView()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColorTheme.TopBackgroundColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(self).inset(20)
        }
        logo.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(containerView).inset(20)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(headingLabel.snp.bottom)
            make.centerX.equalTo(containerView)
        }
        memberNavigation.snp.updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: CalfProfileHeaderViewModel) {
        if let avatarImageUrl = viewModel.avatarImageUrl {
            logo.kf.setImage(with: URL(string: avatarImageUrl)!,
                             placeholder: UIImage(named: viewModel.avatar))
        } else {
            logo.image = UIImage(named: viewModel.avatar)
        }
        headingLabel.text = viewModel.name
        subHeadingLabel.text =  viewModel.memberSince
        
        memberNavigation.delegate = viewModel.memberNavigationDelegate
        memberNavigation.setSelectedButton(viewModel.memberNavigationState)
        memberNavigation.bringSubview(toFront: containerView)
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
}
