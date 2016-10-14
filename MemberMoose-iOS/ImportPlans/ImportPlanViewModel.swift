//
//  ImportPlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ImportPlanViewModel {
    var cellID: String = "PlanCell"
    var cellClass: UITableViewCell.Type = ImportPlanTableViewCell.self
    
    let plan: Plan
    let planName: String
    let planAmount: String
    var selected: Bool
    
    init(plan: Plan) {
        self.plan = plan
        self.planName = plan.name
        self.planAmount = "\(plan.amount)"
        self.selected = false
    }
    
    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) ->  ImportPlanTableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ImportPlanCellIdentifier", forIndexPath: indexPath) as? ImportPlanTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
}
