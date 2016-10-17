//
//  PaymentCardViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PaymentCardViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentCardCell"
    var cellClass: UITableViewCell.Type = SubscriptionCell.self
    
    let nameOnCard: String
    let cardDescription: String
    let cardExpiration: String
    
    init(paymentCard: PaymentCard) {
        nameOnCard = paymentCard.nameOnCard
        cardDescription = "Discover ending in \(paymentCard.cardLastFour)"
        cardExpiration = "Expiration: \(paymentCard.expirationMonth)/\(paymentCard.expirationYear)"
    }
    init(nameOnCard: String, cardDescription: String, cardExpiration: String) {
        self.nameOnCard = nameOnCard
        self.cardDescription = cardDescription
        self.cardExpiration = cardExpiration
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCardCellIdentifier", forIndexPath: indexPath) as? PaymentCardTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView {
        let header = SubscriptionHeaderView()
        header.setup("Payment Card")
        
        return header
    }
}
class PaymentCardHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Large)
        
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