//
//  ProfileCollectionViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/8/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ProfileCollectionViewCellDelegate: class {
    func didSelectMember(member: User)
    func didSelectPlan(plan: Plan)
}
class ProfileCollectionViewCell: UICollectionViewCell {
    weak var profileCollectionViewCellDelegate: ProfileCollectionViewCellDelegate?
    var membershipNavigationState: MembershipNavigationState = .members
    var memberNavigationState: MemberNavigationState = .profile
    var profileType: ProfileType = .bull
    
    fileprivate var cellHeightCache: [String: CGSize] = [:]
    fileprivate let calfProfileCellIdentifier       = "CalfProfileHeaderCellIdentifier"
    fileprivate let profileCellIdentifier           = "ProfileHeaderCellIdentifier"
    fileprivate let subscriptionCellIdentifier                  = "SubscriptionCellIdentifier"
    fileprivate let subscriptionEmptyStateCellIdentifier        = "SubscriptionEmptyStateCellIdentifier"
    fileprivate let paymentCardCellIdentifier       = "PaymentCardCellIdentifier"
    fileprivate let paymentCardEmptyStateCellIdentifier       = "PaymentCardEmptyStateCellIdentifier"
    fileprivate let paymentHistoryCellIdentifier       = "PaymentHistoryCellIdentifier"
    fileprivate let paymentHistoryEmptyStateCellIdentifier       = "PaymentHistoryEmptyStateCellIdentifier"
    fileprivate let chargeCellIdentifier            = "ChargeCellIdentifier"
    fileprivate let messagesCellIdentifier          = "MessagesCellIdentifier"
    fileprivate let messagesEmptyStateCellIdentifier          = "MessagesEmptyStateCellIdentifier"
    fileprivate let memberCellIdentifier            = "MemberCellIdentifier"
    fileprivate let memberEmptyStateCellIdentifier  = "MemberEmptyStateCellIdentifier"
    fileprivate let memberNameCellIdentifier  = "MemberNameCellIdentifier"
    fileprivate let memberEmailAddressCellIdentifier  = "MemberEmailAddressCellIdentifier"
    fileprivate let planCellIdentifier              = "PlanCellIdentifier"
    fileprivate let planEmptyStateCellIdentifier    = "PlanEmptyStateCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120

    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
            
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    fileprivate lazy var tableView: UITableView = {
        let _tableView                  = UITableView(frame: CGRect.zero, style: .grouped)
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.white
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsets.zero
        _tableView.layoutMargins        = UIEdgeInsets.zero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = self.tableCellHeight
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.contentInset         = UIEdgeInsets.zero
        //_tableView.separatorStyle       = .None
        _tableView.isScrollEnabled      = false
        
        _tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.register(CalfProfileHeaderCell.self, forCellReuseIdentifier: self.calfProfileCellIdentifier)
        _tableView.register(SubscriptionCell.self, forCellReuseIdentifier: self.subscriptionCellIdentifier)
        _tableView.register(SubscriptionEmptyStateCell.self, forCellReuseIdentifier: self.subscriptionEmptyStateCellIdentifier)
        _tableView.register(PaymentCardTableViewCell.self, forCellReuseIdentifier: self.paymentCardCellIdentifier)
        _tableView.register(PaymentCardEmptyStateCell.self, forCellReuseIdentifier: self.paymentCardEmptyStateCellIdentifier)
        _tableView.register(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: self.paymentHistoryCellIdentifier)
        _tableView.register(PaymentHistoryEmptyStateCell.self, forCellReuseIdentifier: self.paymentHistoryEmptyStateCellIdentifier)
        _tableView.register(ChargeCell.self, forCellReuseIdentifier: self.chargeCellIdentifier)
        _tableView.register(MessagesCell.self, forCellReuseIdentifier: self.messagesCellIdentifier)
        _tableView.register(MessagesEmptyStateCell.self, forCellReuseIdentifier: self.messagesEmptyStateCellIdentifier)
        _tableView.register(MemberCell.self, forCellReuseIdentifier: self.memberCellIdentifier)
        _tableView.register(MemberEmptyStateCell.self, forCellReuseIdentifier: self.memberEmptyStateCellIdentifier)
        _tableView.register(MemberNameCell.self, forCellReuseIdentifier: self.memberNameCellIdentifier)
        _tableView.register(MemberEmailAddressCell.self, forCellReuseIdentifier: self.memberEmailAddressCellIdentifier)
        _tableView.register(PlanCell.self, forCellReuseIdentifier: self.planCellIdentifier)
        _tableView.register(PlanEmptyStateCell.self, forCellReuseIdentifier: self.planEmptyStateCellIdentifier)
        
        self.addSubview(_tableView)
        return _tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        //contentView.backgroundColor = WWColor.white
    }
    override func updateConstraints() {
        tableView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        super.updateConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getTableViewHeight() -> CGFloat {
        tableView.reloadData()
        tableView.layoutIfNeeded()

        var height:CGFloat = 0
        for (_, value) in cellHeightCache {
            height += value.height
        }
        return height
    }
}
extension ProfileCollectionViewCell : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItems = dataSource[section]
        
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        let viewModel = dataItems[(indexPath as NSIndexPath).row]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width:CGFloat = UIScreen.main.bounds.width
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        let viewModel = dataItems[(indexPath as NSIndexPath).row]
        let cell = viewModel.cellClass.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        if let cell = cell as? DataSourceItemCell {
            cell.setupWith(viewModel)
        }
        cell.updateConstraints()

        let height = cell.contentView.systemLayoutHeightForWidth(width: width)
        
        let size = CGSize(width: width, height: ceil(height))
        
        cellHeightCache["\(viewModel.cellID)\(indexPath.row)"] = size
        
        return size.height
    }
}
extension ProfileCollectionViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        
        if let viewModel = dataItems[(indexPath as NSIndexPath).row] as? MemberViewModel {
            profileCollectionViewCellDelegate?.didSelectMember(member: viewModel.user)
        }
        if let viewModel = dataItems[(indexPath as NSIndexPath).row] as? PlanViewModel  {
             profileCollectionViewCellDelegate?.didSelectPlan(plan: viewModel.plan)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
            
            return view.viewForHeader()
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
            
            return view.heightForHeader()
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
