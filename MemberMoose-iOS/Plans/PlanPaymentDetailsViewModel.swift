//
//  PaymentDetailsViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

class PlanPaymentDetailsViewModel:DataSourceItemProtocol {
    var cellID: String = "PlanPaymentDetailsCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanPaymentDetailsCell.self
    
    let signUpFeeHeader: String
    let signUpFee: String
    let recurringAmountHeader: String
    let recurringAmount: String
    
    init(plan: Plan) {
        self.signUpFeeHeader = "One-Time SignUp Fee"
        self.signUpFee = USD(0).description
        self.recurringAmountHeader = "Recurring Amount"
        self.recurringAmount = "\(USD(plan.amount).description) \(plan.interval!)"
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanPaymentDetailsCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Payment Details")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
