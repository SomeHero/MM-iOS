//
//  PlanFeatureViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanFeatureViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanFeatureCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeatureCell.self
    
    let feature: String
    
    init(feature: String) {
        self.feature = feature
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? PlanFeatureCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Features")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}