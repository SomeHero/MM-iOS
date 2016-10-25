//
//  SubscriptionViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money
protocol SubscriptionDelegate: class {
    func didCancelSubscription(subscription: Subscription)
    func didChangeSubscription(subscription: Subscription)
    func didHoldSubscription(subscription: Subscription)
}
class SubscriptionViewModel:DataSourceItemProtocol {
    var cellID: String = "SubscriptionCell"
    var cellClass: UITableViewCell.Type = SubscriptionCell.self
    
    let planName: String
    let planAmount: String
    let status: String
    private let subscription: Subscription
    weak var subscriptionDelegate: SubscriptionDelegate?
    
    init(subscription: Subscription, subscriptionDelegate: SubscriptionDelegate? = nil) {
        self.planName = subscription.plan.name
        self.planAmount = "\(USD(subscription.plan.amount/100).description)/\(subscription.plan.interval)"
        self.status = subscription.status
        self.subscription = subscription
        
        self.subscriptionDelegate = subscriptionDelegate
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCellIdentifier", forIndexPath: indexPath) as? SubscriptionCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.subscriptionCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        let header = SubscriptionHeaderView()
        header.setup("Subscriptions")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50;
    }
}
extension SubscriptionViewModel: SubscriptionCellDelegate {
    func didCancelSubscriptionClicked() {
        subscriptionDelegate?.didCancelSubscription(subscription)
    }
    func didChangeSubscriptionClicked() {
        subscriptionDelegate?.didChangeSubscription(subscription)
    }
    func didHoldSubscriptionClicked() {
        subscriptionDelegate?.didHoldSubscription(subscription)
    }
}
class SubscriptionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Default)
        
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