//
//  NewPlanProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/29/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class NewPlanProfileHeaderViewModel:DataSourceItemProtocol {
    var cellID: String = "NewPlanProfileHeaderCellIdentifier"
    var cellClass: UITableViewCell.Type = NewPlanProfileHeaderCell.self
    
    let avatar: String
    var avatarImageUrl: String?
    let planName: String?
    let membersCount: String?
    let planNavigationState: PlanNavigationState
    let planNavigationDelegate: PlanNavigationDelegate?
    
    init(plan: Plan, planNavigationState: PlanNavigationState, planNavigationDelegate: PlanNavigationDelegate? = nil) {
        self.avatar = "Avatar-Bull"
        self.planName = plan.name
        self.membersCount = "\(plan.memberCount) Members"
        self.planNavigationState = planNavigationState
        self.planNavigationDelegate = planNavigationDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewPlanProfileHeaderCellIdentifier", for: indexPath) as? NewPlanProfileHeaderCell else {
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