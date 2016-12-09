//
//  NewPlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

class NewPlanViewModel: DataSourceItemProtocol {
    internal var cellID: String = "NewPlanCellIdentifier"

    static let cellID: String = "NewPlanCellIdentifier"
    var cellClass: UITableViewCell.Type = NewPlanCell.self
    
    let plan: Plan
    let planName: String?
    let planAmount: String
    var selected: Bool
    
    init(plan: Plan) {
        self.plan = plan
        self.planName = plan.name
        if let amount = plan.amount, let interval = plan.interval {
            self.planAmount = "\(USD(amount).description)/\(interval)"
        } else {
            self.planAmount = "Amount not set"
        }
        self.selected = false
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPlanViewModel.cellID, for: indexPath) as? NewPlanCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("New Plan")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
