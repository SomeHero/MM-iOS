//
//  PlanSubscribersViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanSubscriberViewModel: DataSourceItemProtocol {
    var cellID: String = "PlanSubscriberCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanSubscriberCell.self
    
    let avatar: String
    var avatarUrl: String?
    var memberName: String?
    let planName: String
    let memberSince: Date
    
    init(user: User) {
        self.avatar = "Avatar-Calf"
        if let avatar = user.avatar, let avatarImageUrl = avatar["large"] {
            avatarUrl = avatarImageUrl
        }
        if let firstName = user.firstName, let lastName = user.lastName {
            memberName = "\(firstName) \(lastName)"
        } else {
            memberName = user.emailAddress
        }
        planName = (user.memberships.flatMap { $0.planNames } as [String]).joined(separator: ", ")
        memberSince = Date()
    }
    
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) ->  UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanSubscriberCell else {
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
