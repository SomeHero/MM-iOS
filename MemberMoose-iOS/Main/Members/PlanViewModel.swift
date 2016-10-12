//
//  PlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanViewModel {
    var cellID: String = "PlanCell"
    var cellClass: UITableViewCell.Type = PlanCell.self
    
    let planId: String
    let planName: String
    let planAmount: Double
    let subscribersCount: Int
    
    init(plan: Plan) {
        planId = plan.planId
        planName = plan.name
        planAmount = plan.amount
        subscribersCount = 23
    }
    
    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) ->  PlanCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlanCellIdentifier", forIndexPath: indexPath) as? PlanCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
}
