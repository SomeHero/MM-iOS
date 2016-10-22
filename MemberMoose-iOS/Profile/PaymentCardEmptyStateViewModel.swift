//
//  PaymentCardEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PaymentCardEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentCardEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = PaymentCardEmptyStateCell.self
    
    let header: String
    
    init(header: String) {
        self.header = header
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? PaymentCardEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PaymentCardHeaderView()
        header.setup("PaymentCard")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}

