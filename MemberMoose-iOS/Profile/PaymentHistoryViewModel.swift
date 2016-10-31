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
    
    lazy var currencyFormatter: NSNumberFormatter = {
        let _formatter = NSNumberFormatter()
        _formatter.generatesDecimalNumbers = true
        _formatter.numberStyle = .CurrencyStyle
        
        return _formatter
    }()
    init(charge: Charge) {
        transactionDate = dateFormatter.stringFromDate(charge.chargeCreated)
        transactionDescription = charge.description
        cardDescription = charge.cardInfo
        amount = USD(charge.amount).description
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PaymentHistoryCellIdentifier", forIndexPath: indexPath) as? PaymentHistoryTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
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
        _label.font = UIFontTheme.Regular()
        
        self.addSubview(_label)
        
        return _label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(title: String) {
        titleLabel.text = title
    }
}
