//
//  PlanViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

class PlanViewModel: DataSourceItemProtocol {
    var cellID: String = "PlanCell"
    var cellClass: UITableViewCell.Type = PlanCell.self
    
    let plan: Plan
    let avatar: String
    var avatarUrl: String?
    let planId: String?
    let planName: String?
    let planAmount: String?
    let subscribersCount: String
    
    init(plan: Plan) {
        self.plan = plan
        self.avatar = "Avatar-Calf"
        if let avatar = plan.avatar, let avatarImageUrl = avatar["large"] {
            avatarUrl = avatarImageUrl
        }
        planId = plan.id
        planName = plan.name
        if let amount = plan.amount, let interval = plan.interval {
            self.planAmount = "\(USD(amount).description)/\(interval.description)"
        } else {
            self.planAmount = "Amount not set"
        }
        subscribersCount =  "\(plan.memberCount) Subscribers"
    }
    
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) ->  UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCellIdentifier", for: indexPath) as? PlanCell else {
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
