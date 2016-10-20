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
    
    init(user: User) {
        self.avatar = "Avatar-Bull"
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            self.avatarImageUrl = avatarImageUrl
        }
        self.companyName = user.companyName
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCellIdentifier", forIndexPath: indexPath) as? ProfileHeaderCell else {
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

