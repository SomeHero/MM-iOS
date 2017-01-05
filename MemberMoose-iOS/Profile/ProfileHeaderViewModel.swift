//
//  ProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ProfileHeaderViewModel:DataSourceItemProtocol {
    var cellID: String = "ProfileHeaderCellIdentifier"
    var cellClass: UITableViewCell.Type = ProfileHeaderCell.self
    
    let avatar: String
    var avatarImageUrl: String?
    let companyName: String?
    let membersCount: String?
    let membershipNavigationState: MembershipNavigationState
    let membershipNavigationDelegate: MembershipNavigationDelegate?
    
    init(user: User, membershipNavigationState: MembershipNavigationState, membershipNavigationDelegate: MembershipNavigationDelegate? = nil) {
        self.avatar = "Avatar-Bull"
        if let account = user.account, let avatar = account.avatar, let avatarImageUrl = avatar["large"] {
            self.avatarImageUrl = avatarImageUrl
        }
        self.companyName = user.account?.companyName
        self.membersCount = "\(user.plans.map({ $0.memberCount }).reduce(0, +)) Members"
        self.membershipNavigationState = membershipNavigationState
        self.membershipNavigationDelegate = membershipNavigationDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellIdentifier", for: indexPath) as? ProfileHeaderCell else {
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

