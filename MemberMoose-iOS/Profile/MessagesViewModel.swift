//
//  MessagesViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class MessagesViewModel:DataSourceItemProtocol {
    var cellID: String = "MessagesCellIdentifier"
    var cellClass: UITableViewCell.Type = MessagesCell.self
    
    let totalCellHeight: CGFloat
    var messages: [Message]
    weak var messageViewDelegate: MessageViewDelegate?
    
    init(totalCellHeight: CGFloat, messages: [Message], messageViewDelegate: MessageViewDelegate? = nil) {
        self.totalCellHeight = totalCellHeight
        self.messages = messages
        self.messageViewDelegate = messageViewDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessagesCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
