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
        if let oneTimeAmount = plan.oneTimeAmount {
            self.signUpFee = USD(oneTimeAmount).description
        } else {
            self.signUpFee = "No signup fee"
        }
        self.recurringAmountHeader = "Recurring Amount"
        if let amount = plan.amount, let interval = plan.interval {
            self.recurringAmount = "\(USD(amount).description)/\(interval)"
        } else {
            self.recurringAmount = "Amount not set"
        }
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
