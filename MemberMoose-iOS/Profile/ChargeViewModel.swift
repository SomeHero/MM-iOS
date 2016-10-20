//
//  ChargeViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class ChargeViewModel:DataSourceItemProtocol {
    var cellID: String = "ChargeCellIdentifier"
    var cellClass: UITableViewCell.Type = ChargeCell.self
    
    let totalCellHeight: CGFloat

    init(totalCellHeight: CGFloat) {
        self.totalCellHeight = totalCellHeight
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? ChargeCell else {
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
