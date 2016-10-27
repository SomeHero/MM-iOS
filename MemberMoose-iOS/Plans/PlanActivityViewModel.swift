//
//  PlanActivityViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanActivityViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanActivityCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeatureCell.self
    
    let activity: String
    
    init(activity: String) {
        self.activity = activity
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? PlanActivityCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Activity")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}