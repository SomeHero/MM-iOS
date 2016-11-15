//
//  PlanSubscriberEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanSubscriberEmptyStateDelegate: class {
    func didCreatePlanSubscriber()
    func didSharePlanToSubscriber()
}
class PlanSubscriberEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanSubscriberEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanSubscriberEmptyStateCell.self
    
    let logo: String
    let header: String
    let subHeader: String
    weak var planSubscriberEmptyStateDelegate: PlanSubscriberEmptyStateDelegate?
    
    init(logo: String, header: String, subHeader: String, planSubscriberEmptyStateDelegate: PlanSubscriberEmptyStateDelegate) {
        self.logo = logo
        self.header = header
        self.subHeader = subHeader
        self.planSubscriberEmptyStateDelegate = planSubscriberEmptyStateDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanSubscriberEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.planSubscriberEmptyStateCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
extension PlanSubscriberEmptyStateViewModel: PlanSubscriberEmptyStateCellDelegate {
    func didCreatePlanSubscriberClicked() {
        planSubscriberEmptyStateDelegate?.didCreatePlanSubscriber()
    }
    func didSharePlanToSubscriberClicked() {
        planSubscriberEmptyStateDelegate?.didSharePlanToSubscriber()
    }
}
