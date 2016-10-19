//
//  MenuTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MenuItemViewModel:DataSourceItemProtocol {
    var cellID: String = "MenuItemCell"
    var cellClass: UITableViewCell.Type = MenuItemCell.self
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCellIdentifier", forIndexPath: indexPath) as? MenuItemCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
}
