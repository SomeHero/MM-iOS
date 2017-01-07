//
//  ActivityEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 1/6/17.
//  Copyright © 2017 James Rhodes. All rights reserved.
//

import Foundation


class ActivityEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "ActivityEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = ActivityEmptyStateTableViewCell.self
    
    let header: String
    
    init(header: String) {
        self.header = header
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ActivityEmptyStateTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return 0
    }
}
