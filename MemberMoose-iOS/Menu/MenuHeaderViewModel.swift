//
//  MenuHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class MenuHeaderViewModel:DataSourceItemProtocol {
    var cellID: String = "MenuHeaderCell"
    var cellClass: UITableViewCell.Type = MenuItemCell.self
    
    let avatar: String
    var avatarUrl: String?
    var name: String?
    var emailAddress: String?
    var menuHeaderDelegate: MenuHeaderDelegate?
    
    init(user: User, menuHeaderDelegate: MenuHeaderDelegate?) {
        self.avatar = "Avatar-Bull"
        if let avatar = user.avatar, let avatarImageUrl = avatar["large"] {
            avatarUrl = avatarImageUrl
        }
        if let firstName = user.firstName, let lastName = user.lastName {
            self.name = "\(firstName) \(lastName)"
        }
        if let emailAddress = user.emailAddress {
            self.emailAddress = emailAddress
        }
        self.menuHeaderDelegate = menuHeaderDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCellIdentifier", for: indexPath) as? MenuHeaderCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.delegate = menuHeaderDelegate
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return 0;
    }
}
