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
    
    let memberId: String
    let memberName: String?
    let emailAddress: String
    let planName: String
    let memberSince: NSDate
    
    init(member: Member) {
        memberId = member.memberId
        memberName = member.name
        emailAddress = member.emailAddress
        planName = "Membermoose Prime"
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
