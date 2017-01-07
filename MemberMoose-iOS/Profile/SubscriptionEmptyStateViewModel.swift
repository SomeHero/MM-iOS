//
//  SubscriptionEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol SubscriptionEmptyStateDelegate: class {
    func didSubscribe()
}
class SubscriptionEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "SubscriptionEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = SubscriptionEmptyStateCell.self
    weak var subscriptionEmptyStateDelegate: SubscriptionEmptyStateDelegate?
    
    let header: String
    
    init(header: String, subscriptionEmptyStateDelegate: SubscriptionEmptyStateDelegate? = nil) {
        self.header = header
        self.subscriptionEmptyStateDelegate = subscriptionEmptyStateDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SubscriptionEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.subscriptionEmptyStateCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Subscriptions")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension SubscriptionEmptyStateViewModel: SubscriptionEmptyStateCellDelegate {
    func didSubscribeClicked() {
        subscriptionEmptyStateDelegate?.didSubscribe()
    }
}
