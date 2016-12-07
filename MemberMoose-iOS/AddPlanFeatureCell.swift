//
//  AddPlanFeatureCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class AddPlanFeatureCell: UITableViewCell {
    static let cellID: String = "AddPlanFeaturesCellIdentifier"
    var cellClass: UITableViewCell.Type = AddPlanFeatureCell.self
    weak var planFeaturesCell: UITableViewCell?
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
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
        featureLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }
        editButton.snp.updateConstraints { (make) in
            make.leading.equalTo(featureLabel.snp.trailing)
            make.trailing.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }

        planFeaturesCell?.updateConstraints()
        
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? AddPlanFeatureViewModel {
            featureLabel.text = "Add Feature"
            planFeaturesCell = viewModel.planFeaturesCell
            
            viewModel.planFeaturesCell?.updateConstraints()
            
            TextDecorator.applyTightLineHeight(toLabel: featureLabel)
        }
    }
}
