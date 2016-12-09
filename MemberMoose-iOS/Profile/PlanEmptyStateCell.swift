//
//  PlanEmptyStateCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanEmptyStateCellDelegate: class {
    func didCreatePlanClicked()
    func didImportPlanClicked()
}
class PlanEmptyStateCell: UITableViewCell, DataSourceItemCell {
    weak var planEmptyStateCellDelegate: PlanEmptyStateCellDelegate?
    
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
    fileprivate lazy var createPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(PlanEmptyStateCell.createPlanClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("CREATE A PLAN", for: UIControlState())
        
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var importPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(PlanEmptyStateCell.importPlanClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("IMPORT A PLAN", for: UIControlState())
        
        self.buttonContainer.addSubview(_button)
        
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
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? PlanEmptyStateViewModel else {
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
        createPlanButton.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(buttonContainer)
            make.height.equalTo(50)
        }
        importPlanButton.snp.updateConstraints { (make) in
            make.top.equalTo(createPlanButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(buttonContainer)
            make.bottom.equalTo(buttonContainer)
            make.height.equalTo(50)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func createPlanClicked(_ sender: UIButton) {
        planEmptyStateCellDelegate?.didCreatePlanClicked()
    }
    func importPlanClicked(_ sender: UIButton) {
        planEmptyStateCellDelegate?.didImportPlanClicked()
    }
}
