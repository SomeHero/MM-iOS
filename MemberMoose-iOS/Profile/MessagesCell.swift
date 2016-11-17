//
//  MessagesCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SlackTextViewController

class MessagesCell: UITableViewCell {
    fileprivate lazy var messageView: MessageView = {
        let _messageViewController = MessageView()
 
        self.contentView.addSubview(_messageViewController.view)
        
        return _messageViewController
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        
        //selectedBackgroundView = selectedColorView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func updateConstraints() {
//        messageView.view.snp.updateConstraints { (make) -> Void in
//            make.edges.equalTo(contentView)
//        }
        super.updateConstraints()
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? MessagesViewModel {
            messageView.dataSource = viewModel.messages
            messageView.messageViewDelegate = viewModel.messageViewDelegate
            messageView.view.snp.updateConstraints { (make) in
                make.edges.equalTo(contentView)
                make.height.equalTo(viewModel.totalCellHeight)
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
}
