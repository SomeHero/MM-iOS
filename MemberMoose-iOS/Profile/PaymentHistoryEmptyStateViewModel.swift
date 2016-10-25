//
//  PaymentHistoryEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PaymentHistoryEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentHistoryEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = SubscriptionEmptyStateCell.self
    
    let header: String
    
    init(header: String) {
        self.header = header
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? PaymentHistoryEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PaymentHistoryHeaderView()
        header.setup("Payment History")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
