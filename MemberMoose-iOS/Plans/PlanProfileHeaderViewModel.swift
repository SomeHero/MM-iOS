//
//  PlanProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol PlanProfileHeaderViewModelDelegate: class {
    func didUpdatePlanAvatar(avatar: UIImage)
}
class PlanProfileHeaderViewModel:DataSourceItemProtocol {
    weak var planProfileHeaderViewModelDelegate: PlanProfileHeaderViewModelDelegate?
    
    var cellID: String = "PlanProfileHeaderCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanProfileHeaderCell.self
    
    let avatar: String
    var avatarImageUrl: String?
    let planName: String?
    let membersCount: String?
    let planNavigationState: PlanNavigationState
    let planNavigationDelegate: PlanNavigationDelegate?
    weak var presentingViewController: UIViewController?
    
    init(plan: Plan, planNavigationState: PlanNavigationState, planNavigationDelegate: PlanNavigationDelegate? = nil) {
        self.avatar = "Avatar-Bull"
        if let avatar = plan.avatar, let avatarImageUrl = avatar["large"] {
            self.avatarImageUrl = avatarImageUrl
        }
        self.planName = plan.name
        self.membersCount = "\(plan.memberCount) Members"
        self.planNavigationState = planNavigationState
        self.planNavigationDelegate = planNavigationDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlanProfileHeaderCellIdentifier", for: indexPath) as? PlanProfileHeaderCell else {
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

