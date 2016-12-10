//
//  PlanSubscriberEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation


class PlanSubscriberEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanSubscriberEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanSubscriberEmptyStateCell.self
    
    let header: String

    init(plan: Plan) {
        if let planName = plan.name {
            self.header = "\(planName) has no subscribers."
        } else {
            self.header = "Your plan has no subscribers."
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanSubscriberEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)

        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
