//
//  CalfProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class CalfProfileHeaderViewModel:DataSourceItemProtocol {
    var cellID: String = "CalfProfileHeaderCellIdentifier"
    var cellClass: UITableViewCell.Type = CalfProfileHeaderCell.self
    
    let avatar: String
    var avatarImageUrl: String?
    let name: String?
    let memberSince: String
    let memberNavigationState: MemberNavigationState
    let memberNavigationDelegate: MemberNavigationDelegate?
    
    init(user: User, memberNavigationState: MemberNavigationState, memberNavigationDelegate: MemberNavigationDelegate? = nil) {
        self.avatar = "Avatar-Calf"
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            self.avatarImageUrl = avatarImageUrl
        }
        if let firstName = user.firstName, lastName = user.lastName {
            self.name = "\(firstName) \(lastName)"
        } else {
            self.name = user.emailAddress
        }
        self.memberSince = "Member Since Jan 2015"
        self.memberNavigationState = memberNavigationState
        self.memberNavigationDelegate = memberNavigationDelegate
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("CalfProfileHeaderCellIdentifier", forIndexPath: indexPath) as? CalfProfileHeaderCell else {
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

