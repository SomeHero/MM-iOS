//
//  ImportPlanTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ImportPlanTableViewCell: UITableViewCell {

    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var radioBoxImageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .ScaleAspectFit
        
        self.contentView.addSubview(_imageView)
        
        return _imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(viewModel: ImportPlanViewModel) {
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = viewModel.planAmount
        
        if viewModel.selected {
            radioBoxImageView.image = UIImage(named: "Radio-Checked")
        } else {
            radioBoxImageView.image = UIImage(named: "Radio-Unchecked")
        }
    }
    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        planNameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        radioBoxImageView.snp_updateConstraints { (make) in
            make.leading.equalTo(containerView.snp_trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.bottom.equalTo(containerView)
            make.height.width.equalTo(34)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}
