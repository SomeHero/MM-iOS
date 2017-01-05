//
//  PlanProfileCollectionViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/8/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol PlanProfileCollectionViewCellDelegate: class {
    func didSelectPlanProfileRow(viewModel: DataSourceItemProtocol)
}
class PlanProfileCollectionViewCell: UICollectionViewCell {
    weak var delegate: PlanProfileCollectionViewCellDelegate?
    
    fileprivate let profileCellIdentifier           = "PlanProfileHeaderCellIdentifier"
    fileprivate let newProfileCellIdentifier           = "NewPlanProfileHeaderCellIdentifier"
    fileprivate let planPaymentCellIdentifier       = "PlanPaymentDetailsCellIdentifier"
    fileprivate let planNameCellIdentifier   = "PlanNameCellIdentifier"
    fileprivate let freeTrialPeriodCellIdentifier   = "FreeTrialPeriodCellIdentifier"
    fileprivate let planSignUpFeeCellIdentifier   = "PlanSignUpFeeCellIdentifier"
    fileprivate let planAmountCellIdentifier      = "PlanAmountCellIdentifier"
    fileprivate let planDescriptionCellIdentifier   = "PlanDescriptionCellIdentifier"
    fileprivate let planFeaturesCellIdentifier       = "PlanFeaturesCellIdentifier"
    fileprivate let addPlanFeaturesCellIdentifier       = "AddPlanFeaturesCellIdentifier"
    fileprivate let planTermsOfServiceCellIdentifier = "PlanTermsOfServiceCellIdentifier"
    fileprivate let planSubscriberEmptyStateCellIdentifier    = "PlanSubscriberEmptyStateCellIdentifier"
    fileprivate let planSubscriberCellIdentifier    = "PlanSubscriberCellIdentifier"
    fileprivate let planActivityCellIdentifier      = "PlanActivityCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120

    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
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
        
        _tableView.register(PlanProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.register(NewPlanProfileHeaderCell.self, forCellReuseIdentifier: self.newProfileCellIdentifier)
        _tableView.register(PlanSignUpFeeCell.self, forCellReuseIdentifier: self.planSignUpFeeCellIdentifier)
        _tableView.register(PlanAmountCell.self, forCellReuseIdentifier: self.planAmountCellIdentifier)
        _tableView.register(PlanPaymentDetailsCell.self, forCellReuseIdentifier: self.planPaymentCellIdentifier)
        _tableView.register(PlanNameCell.self, forCellReuseIdentifier: self.planNameCellIdentifier)
        _tableView.register(PlanDescriptionCell.self, forCellReuseIdentifier: self.planDescriptionCellIdentifier)
        _tableView.register(FreeTrialPeriodCell.self, forCellReuseIdentifier    : self.freeTrialPeriodCellIdentifier)
        _tableView.register(PlanFeaturesCell.self, forCellReuseIdentifier: self.planFeaturesCellIdentifier)
        _tableView.register(AddPlanFeatureCell.self, forCellReuseIdentifier: self.addPlanFeaturesCellIdentifier)
        _tableView.register(PlanTermsOfServiceCell.self, forCellReuseIdentifier: self.planTermsOfServiceCellIdentifier)
        _tableView.register(PlanSubscriberCell.self, forCellReuseIdentifier: self.planSubscriberCellIdentifier)
        _tableView.register(PlanSubscriberEmptyStateCell.self, forCellReuseIdentifier: self.planSubscriberEmptyStateCellIdentifier)
        _tableView.register(PlanActivityCell.self, forCellReuseIdentifier: self.planActivityCellIdentifier)
        
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
        for (_, value) in PlanProfileCollectionViewCell.cellHeightCache {
            height += value.height
        }
        return height
    }
}
extension PlanProfileCollectionViewCell : UITableViewDataSource {
    fileprivate static var cellHeightCache: [String: CGSize] = [:]
    
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
        
        if let referenceSize = PlanProfileCollectionViewCell.cellHeightCache["\(viewModel.cellID)\(indexPath.row)"] {
            return referenceSize.height
        }
        
        let cell = viewModel.cellClass.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        if let cell = cell as? DataSourceItemCell {
            cell.setupWith(viewModel)
        }
        cell.updateConstraints()
        
        let height = cell.contentView.systemLayoutHeightForWidth(width: width)
        
        let size = CGSize(width: width, height: ceil(height))
        
        PlanProfileCollectionViewCell.cellHeightCache["\(viewModel.cellID)\(indexPath.row)"] = size
        
        return size.height
    }
}
extension PlanProfileCollectionViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
//        
//        switch planNavigationState {
//        case .subscribers:
//            guard let viewModel = dataItems[(indexPath as NSIndexPath).row] as? MemberViewModel else {
//                return
//            }
//            
//            let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
//            //viewController.profileDelegate = self
//            
//            navigationController?.pushViewController(viewController, animated: true)
//            
//        //profileType = .calf
        //case .details:
        let viewModel = dataItems[(indexPath as NSIndexPath).row]
        
        delegate?.didSelectPlanProfileRow(viewModel: viewModel)
//        case .activity:
//            break;
//        }
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
        if let referenceSize = PlanProfileCollectionViewCell.cellHeightCache["Header\(section)"]  {
            return referenceSize.height
        }
        let width:CGFloat = UIScreen.main.bounds.width
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
            let height = view.heightForHeader()
            let size = CGSize(width: width, height: height)
            
            PlanProfileCollectionViewCell.cellHeightCache["Header\(section)"] = size
        
            return size.height
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
