//
//  PlanEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanEmptyStateDelegate: class {
    func didCreatePlan()
    func didImportPlan()
}
class PlanEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanEmptyStateCell.self
    
    let logo: String
    let header: String
    let subHeader: String
    weak var planEmptyStateDelgate: PlanEmptyStateDelegate?
    
    init(logo: String, header: String, subHeader: String, planEmptyStateDelgate: PlanEmptyStateDelegate? = nil) {
        self.logo = logo
        self.header = header
        self.subHeader = subHeader
        self.planEmptyStateDelgate = planEmptyStateDelgate
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? PlanEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.planEmptyStateCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.min;
    }
}
extension PlanEmptyStateViewModel: PlanEmptyStateCellDelegate {
    func didCreatePlanClicked() {
        planEmptyStateDelgate?.didCreatePlan()
    }
    func didImportPlanClicked() {
        planEmptyStateDelgate?.didImportPlan()
    }
}