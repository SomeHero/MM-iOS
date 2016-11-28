//
//  ImportPlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

class ImportPlanViewModel {
    var cellID: String = "PlanCell"
    var cellClass: UITableViewCell.Type = ImportPlanTableViewCell.self
    
    let plan: ReferencePlan
    let planName: String
    let planAmount: String
    var selected: Bool
    
    init(plan: ReferencePlan) {
        self.plan = plan
        self.planName = plan.planName
        self.planAmount = "$100.00/month"
        self.selected = false
    }
    
    func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) ->  ImportPlanTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImportPlanCellIdentifier", for: indexPath) as? ImportPlanTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
}
