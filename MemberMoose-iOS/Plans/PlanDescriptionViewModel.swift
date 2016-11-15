//
//  PlanDescriptionViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanDescriptionViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanDescriptionCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanDescriptionCell.self
    
    let description: String
    
    init(plan: Plan) {
        if let description = plan.description {
            self.description = description
        } else {
            self.description = "No description provided"
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanDescriptionCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Description")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
