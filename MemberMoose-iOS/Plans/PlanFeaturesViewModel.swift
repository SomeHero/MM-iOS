//
//  PlanFeaturesViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/29/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PlanFeaturesViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanFeaturesCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeaturesCell.self
    
    let plan: Plan
    weak var planFeaturesDelegate: PlanFeaturesCellDelegate?
    
    init(plan: Plan) {
        self.plan = plan
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanFeaturesCell else {
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
