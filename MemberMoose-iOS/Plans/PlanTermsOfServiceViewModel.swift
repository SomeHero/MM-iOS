//
//  PlanTermsOfServiceViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanTermsOfServiceViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanTermsOfServiceCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanDescriptionCell.self
    
    let termsOfService: String
    
    init(plan: Plan) {
        self.termsOfService = "A membership doesn’t just mean you get to work in a collaborative and creative space, but you become part of a community of freelancers, independents, and start-ups. You’ll get access to events, extra exposure, and chances to start great conversations. \r\r No more hunting for that perfect person to work with on a big project because they are most likely sitting next to you."
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanTermsOfServiceCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Terms of Service")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
