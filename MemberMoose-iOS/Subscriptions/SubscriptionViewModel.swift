//
//  SubscriptionViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SubscriptionViewModel {
    var cellID: String = "SubscriptionCell"
    var cellClass: UITableViewCell.Type = SubscriptionCell.self
    
    let planName: String
    let planAmount: String
    let status: String
    
    init(subscription: Subscription) {
        planName = subscription.plan.name
        planAmount = "$30.00/monthly"
        status = subscription.status
    }
    init(planName: String, planAmount: String, status: String) {
        self.planName = planName
        self.planAmount = planAmount
        self.status = status
    }
    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> SubscriptionCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCellIdentifier", forIndexPath: indexPath) as? SubscriptionCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
}