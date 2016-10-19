//
//  MenuItemCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.SecondaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        
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
        titleLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MenuItemViewModel {
            titleLabel.text = viewModel.title
        }
    }
}
