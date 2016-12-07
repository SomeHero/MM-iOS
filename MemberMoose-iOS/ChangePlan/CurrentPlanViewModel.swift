//
//  CurrentPlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

class CurrentPlanViewModel: DataSourceItemProtocol {
    static let cellID: String = "CurrentPlanCellIdentifier"
    var cellClass: UITableViewCell.Type = CurrentPlanCell.self
    
    let plan: Plan
    let planName: String?
    let planAmount: String?
    
    init(plan: Plan) {
        self.plan = plan
        self.planName = plan.name
        if let amount = plan.amount, let interval = plan.interval {
            self.planAmount = "\(USD(amount).description)/\(interval)"
        } else {
            self.planAmount = "Amount not set"
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentPlanViewModel.cellID, for: indexPath) as? CurrentPlanCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Current Plan")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
