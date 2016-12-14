//
//  PlanFeatureCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanFeatureCell: UITableViewCell, DataSourceItemCell {
    static let cellID: String = "PlanFeatureCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeatureCell.self
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var dotImageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage.fontAwesomeIcon(name: .circle, textColor: UIColorTheme.PrimaryFont, size: CGSize(width: 10, height: 10))
        
        self.contentView.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var featureLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var editButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 18)
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .normal)
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: .highlighted)
        _button.setTitle(String.fontAwesomeIcon(name: .pencil), for: .normal)
        _button.backgroundColor = UIColor.clear
        _button.isUserInteractionEnabled = false
        
        self.containerView.addSubview(_button)
        
        return _button
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
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        dotImageView.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.centerY.equalTo(containerView)
        }
        featureLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(dotImageView.snp.trailing).offset(10)
            make.top.bottom.equalTo(containerView)
        }
        editButton.snp.updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(featureLabel.snp.trailing).offset(10)
            make.trailing.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }

        
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanFeatureViewModel {
            featureLabel.text = viewModel.feature
            TextDecorator.applyTightLineHeight(toLabel: featureLabel)
        }
    }
}
