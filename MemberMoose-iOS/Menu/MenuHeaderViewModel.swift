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
    let name: String
    let emailAddress: String
    
    init(user: User) {
        self.avatar = "Avatar-Bull"
        self.name = "Larkin Garbee"
        self.emailAddress = user.emailAddress
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("MenuHeaderCellIdentifier", forIndexPath: indexPath) as? MenuHeaderCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
}