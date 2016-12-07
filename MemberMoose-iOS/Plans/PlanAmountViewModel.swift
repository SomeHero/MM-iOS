//
//  PlanAmountViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

protocol PlanAmountDelegate: class {
    func didUpdatePlanAmount(text: String, interval: RecurringInterval)
}
class PlanAmountViewModel:DataSourceItemProtocol {
    weak var planAmountDelegate: PlanAmountDelegate?
    
    var cellID: String = "PlanAmountCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanAmountCell.self
    
    var amount: Double?
    var interval: RecurringInterval?
    
    init(plan: Plan) {
        if let planAmount = plan.amount {
            self.amount = planAmount
        }
        if let recurringInterval = plan.interval {
            interval = recurringInterval
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanAmountCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = 0.00
        
        if let amount = amount {
            text = amount
        }
        let planAmountEditorViewController = PlanAmountEditorViewController(title: "Recurring Amount", amount: text, interval: interval)
        planAmountEditorViewController.planAmountEditorDelegate = self
        
        viewController.navigationController?.pushViewController(planAmountEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Recurring Amount")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension PlanAmountViewModel: PlanAmountEditorDelegate {
    func didSubmitAmount(amount: String, interval: RecurringInterval) {
        planAmountDelegate?.didUpdatePlanAmount(text: amount, interval: interval)
    }
}
