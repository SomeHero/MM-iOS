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
        if let termsOfService = plan.termsOfService {
            self.termsOfService = termsOfService
        } else {
            self.termsOfService = "No terms of service provided"
        }
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
