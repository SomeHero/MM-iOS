//
//  PaymentCardEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PaymentCardEmptyStateDelegate: class {
    func didAddPaymentCard()
}
class PaymentCardEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "PaymentCardEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = PaymentCardEmptyStateCell.self
    weak var paymentCardEmptyStateDelegate: PaymentCardEmptyStateDelegate?
    
    let header: String
    
    init(header: String, paymentCardEmptyStateDelegate: PaymentCardEmptyStateDelegate?) {
        self.header = header
        self.paymentCardEmptyStateDelegate = paymentCardEmptyStateDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PaymentCardEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.paymentCardEmptyStateCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = PaymentCardHeaderView()
        header.setup("PaymentCard")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
extension PaymentCardEmptyStateViewModel: PaymentCardEmptyStateCellDelegate {
    func didAddPaymentCardClicked() {
        paymentCardEmptyStateDelegate?.didAddPaymentCard()
    }
}
