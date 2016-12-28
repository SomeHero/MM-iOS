//
//  PaymentCardViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol PaymentCardDelegate: class {
    func didUpdatePaymentCard(_ paymentCard: PaymentCard)
}
class PaymentCardViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentCardCellIdentifier"
    var cellClass: UITableViewCell.Type = SubscriptionCell.self
    
    var nameOnCard: String?
    let cardDescription: String
    let cardExpiration: String
    fileprivate var paymentCard: PaymentCard
    weak var paymentCardDelegate: PaymentCardDelegate?
    
    init(paymentCard: PaymentCard, paymentCardDelegate: PaymentCardDelegate? = nil) {
        if let name = paymentCard.nameOnCard {
            nameOnCard = name
        }
        cardDescription = "\(paymentCard.brand!) ending in \(paymentCard.cardLastFour!)"
        cardExpiration = "Expiration: \(paymentCard.expirationMonth!)/\(paymentCard.expirationYear!)"
        self.paymentCard = paymentCard
        self.paymentCardDelegate = paymentCardDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardCellIdentifier", for: indexPath) as? PaymentCardTableViewCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.paymentCardCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PaymentCardHeaderView()
        header.setup("Payment Cards")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
extension PaymentCardViewModel: PaymentCardCellDelegate {
    func didUpdateCardClicked() {
        paymentCardDelegate?.didUpdatePaymentCard(paymentCard)
    }
}
class PaymentCardHeaderView: UIView {
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.font = UIFontTheme.SemiBold(.default)
        
        self.addSubview(_label)
        
        return _label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(_ title: String) {
        titleLabel.text = title
    }
}
