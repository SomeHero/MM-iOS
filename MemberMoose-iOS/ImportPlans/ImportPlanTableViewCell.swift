//
//  ImportPlanTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ImportPlanTableViewCell: UITableViewCell {

    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var radioBoxImageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(_imageView)
        
        return _imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(_ viewModel: ImportPlanViewModel) {
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = viewModel.planAmount
        
        if viewModel.selected {
            radioBoxImageView.image = UIImage(named: "Radio-Checked")
        } else {
            radioBoxImageView.image = UIImage(named: "Radio-Unchecked")
        }
    }
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        planNameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        radioBoxImageView.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
            make.bottom.equalTo(containerView)
            make.height.width.equalTo(34)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
