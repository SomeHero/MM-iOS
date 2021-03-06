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
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PaymentHistoryEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Payment History")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
