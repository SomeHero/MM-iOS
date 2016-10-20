//
//  MemberViewComdel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MemberViewModel {
    var cellID: String = "MemberCell"
    var cellClass: UITableViewCell.Type = MemberCell.self
    
    let user: User
    let avatar: String
    var avatarUrl: String?
    let userId: String
    var memberName: String?
    let emailAddress: String
    let planName: String
    let memberSince: NSDate
    
    init(user: User) {
        self.user = user
        self.avatar = "Avatar-Calf"
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            avatarUrl = avatarImageUrl
        }
        userId = user.id
        if let firstName = user.firstName, lastName = user.lastName {
            memberName = "\(firstName) \(lastName)"
        }
        emailAddress = user.emailAddress
        planName = (user.memberships.flatMap { $0.planNames } as [String]).joinWithSeparator(", ")
        memberSince = NSDate()
    }

    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) ->  MemberCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("MemberCellIdentifier", forIndexPath: indexPath) as? MemberCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
}
