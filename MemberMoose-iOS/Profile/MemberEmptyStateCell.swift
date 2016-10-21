//
//  MemberEmptyStateCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol MemberEmptyStateCellDelegate: class {
    func didCreateMemberClicked()
    func didSharePlanClicked()
}
class MemberEmptyStateCell: UITableViewCell {
    weak var memberEmptyStateCellDelegate: MemberEmptyStateCellDelegate?
    
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .ScaleAspectFit
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    private lazy var createMemberButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MemberEmptyStateCell.createMemberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("ADD A MEMBER", forState: .Normal)
       
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    private lazy var sharePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MemberEmptyStateCell.sharePlanClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("SEND LINK TO PLAN", forState: .Normal)
        
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
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
    func setupWith(viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? MemberEmptyStateViewModel else {
            return
        }
        logo.image = UIImage(named: viewModel.logo)
        headerLabel.text = viewModel.header
        subHeadingLabel.text = viewModel.subHeader
    }
    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.center.equalTo(contentView)
            make.edges.equalTo(contentView).inset(20)
        }
        logo.snp_updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headerLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(headerLabel.snp_bottom)
            make.leading.trailing.equalTo(containerView).inset(40)
        }
        buttonContainer.snp_updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(20)
        }
        createMemberButton.snp_updateConstraints { (make) in
            make.top.leading.trailing.equalTo(buttonContainer)
            make.height.equalTo(50)
        }
        sharePlanButton.snp_updateConstraints { (make) in
            make.top.equalTo(createMemberButton.snp_bottom).offset(10)
            make.leading.trailing.equalTo(buttonContainer)
            make.bottom.equalTo(buttonContainer)
            make.height.equalTo(50)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func createMemberClicked(sender: UIButton) {
        memberEmptyStateCellDelegate?.didCreateMemberClicked()
    }
    func sharePlanClicked(sender: UIButton) {
        memberEmptyStateCellDelegate?.didSharePlanClicked()
    }
}
