//
//  PlanProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanProfileHeaderViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanProfileHeaderCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanProfileHeaderCell.self
    
    let avatar: String
    var avatarImageUrl: String?
    let planName: String?
    let membersCount: String?
    let planNavigationState: PlanNavigationState
    let planNavigationDelegate: PlanNavigationDelegate?
    
    init(plan: Plan, planNavigationState: PlanNavigationState, planNavigationDelegate: PlanNavigationDelegate? = nil) {
        self.avatar = "Avatar-Bull"
        self.planName = plan.name
        self.membersCount = "102 Members"
        self.planNavigationState = planNavigationState
        self.planNavigationDelegate = planNavigationDelegate
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PlanProfileHeaderCellIdentifier", forIndexPath: indexPath) as? PlanProfileHeaderCell else {
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

