//
//  MessagesViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class MessagesViewModel:DataSourceItemProtocol {
    var cellID: String = "MessagesCellIdentifier"
    var cellClass: UITableViewCell.Type = MessagesCell.self
    
    let avatar: String
    let avatarImageUrl: String?
    let name: String?
    let memberSince: String
    let memberNavigationState: MemberNavigationState
    let memberNavigationDelegate: MemberNavigationDelegate?
    
    init(user: User, memberNavigationState: MemberNavigationState, memberNavigationDelegate: MemberNavigationDelegate? = nil) {
        self.avatar = "Avatar-Bull"
        self.avatarImageUrl = nil
        if let firstName = user.firstName, let lastName = user.lastName {
            self.name = "\(firstName) \(lastName)"
        } else {
            self.name = user.emailAddress
        }
        self.memberSince = "Member Since Jan 2015"
        self.memberNavigationState = memberNavigationState
        self.memberNavigationDelegate = memberNavigationDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessagesCell else {
            fatalError(#function)
        }
        
        //cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
