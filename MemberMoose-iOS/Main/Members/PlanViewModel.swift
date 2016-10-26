//
//  PlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

class PlanViewModel: DataSourceItemProtocol {
    var cellID: String = "PlanCell"
    var cellClass: UITableViewCell.Type = PlanCell.self
    
    let plan: Plan
    let planId: String
    let planName: String
    let planAmount: String
    let interval: String
    let subscribersCount: Int
    
    init(plan: Plan) {
        self.plan = plan
        planId = plan.id
        planName = plan.name
        planAmount = "\(USD(plan.amount/100).description)"
        interval = plan.interval
        subscribersCount = 23
    }
    
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) ->  UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlanCellIdentifier", forIndexPath: indexPath) as? PlanCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.min;
    }
}
