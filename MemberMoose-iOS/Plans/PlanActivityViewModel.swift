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
    var cellClass: UITableViewCell.Type = PlanActivityCell.self
    
    let activity: String
    let activityDate: Date
    let dateFormatter = DateFormatters.dateFormatterForLongStyle()
    
    init(activity: Activity) {
        self.activity = activity.messageBull
        self.activityDate = activity.createdAt
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanActivityCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup(dateFormatter.string(from: activityDate))
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 60
    }
}
