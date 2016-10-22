//
//  SubscriptionEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class SubscriptionEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "SubscriptionEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = SubscriptionEmptyStateCell.self
    
    let header: String
    
    init(header: String) {
        self.header = header
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? SubscriptionEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = SubscriptionHeaderView()
        header.setup("Subscriptions")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
