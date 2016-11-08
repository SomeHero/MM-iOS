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
        self.description = "A membership doesn’t just mean you get to work in a collaborative and creative space, but you become part of a community of freelancers, independents, and start-ups. You’ll get access to events, extra exposure, and chances to start great conversations."
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
