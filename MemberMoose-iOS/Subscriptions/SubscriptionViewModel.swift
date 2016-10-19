//
//  SubscriptionViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SubscriptionViewModel:DataSourceItemProtocol {
    var cellID: String = "SubscriptionCell"
    var cellClass: UITableViewCell.Type = SubscriptionCell.self
    
    let planName: String
    let planAmount: String
    let status: String
    
    init(subscription: Subscription) {
        planName = subscription.plan.name
        planAmount = "\(subscription.plan.amount)/\(subscription.plan.interval)"
        status = subscription.status
    }
    init(planName: String, planAmount: String, status: String) {
        self.planName = planName
        self.planAmount = planAmount
        self.status = status
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionCellIdentifier", forIndexPath: indexPath) as? SubscriptionCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView {
        let header = SubscriptionHeaderView()
        header.setup("Subscriptions")
        
        return header
    }
}
class SubscriptionHeaderView: UIView {
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