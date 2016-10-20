//
//  PaymentHistoryViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class PaymentHistoryViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentHistoryCell"
    var cellClass: UITableViewCell.Type = PaymentHistoryTableViewCell.self
    
    let transactionDate: String
    let transactionDescription: String
    let cardDescription: String
    let amount: String
    let dateFormatter = DateFormatters.dateFormatterForMonthDayYear()
    
    lazy var currencyFormatter: NSNumberFormatter = {
        let _formatter = NSNumberFormatter()
        _formatter.generatesDecimalNumbers = true
        _formatter.numberStyle = .CurrencyStyle
        
        return _formatter
    }()
    init(transaction: Transaction) {
        transactionDate = dateFormatter.stringFromDate(transaction.transactionDate)
        transactionDescription = transaction.transactionDescription
        cardDescription = transaction.cardDescription
        amount = "$30.00"
    }
    init(transactionDate: NSDate, transactionDescription: String, cardDescription: String, amount: NSDecimalNumber) {
        self.transactionDate = dateFormatter.stringFromDate(transactionDate)
        self.transactionDescription = transactionDescription
        self.cardDescription = cardDescription
        self.amount = "$30.00"
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PaymentHistoryCellIdentifier", forIndexPath: indexPath) as? PaymentHistoryTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView {
        let header = SubscriptionHeaderView()
        header.setup("Payment History")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
class PaymentHistoryHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Large)
        
        self.addSubview(_label)
        
        return _label
    }()
    func setup(title: String) {
        titleLabel.text = title
    }
}
