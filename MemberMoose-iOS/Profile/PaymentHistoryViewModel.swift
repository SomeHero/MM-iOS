//
//  PaymentHistoryViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

class PaymentHistoryViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentHistoryCell"
    var cellClass: UITableViewCell.Type = PaymentHistoryTableViewCell.self
    
    let transactionDate: String
    let transactionDescription: String?
    let cardDescription: String
    let amount: String
    let dateFormatter = DateFormatters.timeStampDateFormatter
    
    lazy var currencyFormatter: NumberFormatter = {
        let _formatter = NumberFormatter()
        _formatter.generatesDecimalNumbers = true
        _formatter.numberStyle = .currency
        
        return _formatter
    }()
    init(charge: Charge) {
        transactionDate = dateFormatter.string(from: charge.chargeCreated)
        transactionDescription = charge.description
        if let paymentCard = charge.paymentCard {
            cardDescription = "\(paymentCard.brand!) \(paymentCard.cardLastFour!)"
        } else {
            cardDescription = "Unknown Card"
        }
        amount = USD(charge.amount).description
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCellIdentifier", for: indexPath) as? PaymentHistoryTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Payment History")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
