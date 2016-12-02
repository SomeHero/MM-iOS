//
//  PlanFeaturesCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/29/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol PlanFeaturesCellDelegate: class {
    func didSelectItem(feature: String)
}
class PlanFeaturesCell: UITableViewCell {
    weak var planFeaturesCellDelegate: PlanFeaturesCellDelegate?
    
    static let cellID: String = "PlanFeaturesCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeaturesCell.self
    
    var dataSource: [[PlanFeatureViewModel]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView(frame: CGRect.zero, style: .grouped)
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.white
        _tableView.alwaysBounceVertical = false
        _tableView.separatorInset       = UIEdgeInsets.zero
        _tableView.layoutMargins        = UIEdgeInsets.zero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = 80
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.contentInset         = UIEdgeInsets.zero
        _tableView.separatorStyle       = .none
        
        _tableView.register(PlanFeatureCell.self, forCellReuseIdentifier: PlanFeatureCell.cellID)
        _tableView.register(NewPlanCell.self, forCellReuseIdentifier:  NewPlanViewModel.cellID)
        
        self.contentView.addSubview(_tableView)
        return _tableView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        selectionStyle = .none
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func updateConstraints() {
        tableView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(1000)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanFeaturesViewModel {
            if let features = viewModel.plan.features {
                var planFeaturesViewModels: [PlanFeatureViewModel] = []
                for feature in features {
                    let planFeatureViewModel = PlanFeatureViewModel(feature: feature)
                    
                    planFeaturesViewModels.append(planFeatureViewModel)
                }
                dataSource = [planFeaturesViewModels]
            }
            planFeaturesCellDelegate = viewModel.planFeaturesDelegate
        }
    }
}
extension PlanFeaturesCell: UITableViewDataSource {
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
}
extension PlanFeaturesCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        
        let viewModel = dataItems[(indexPath as NSIndexPath).row]
        
        planFeaturesCellDelegate?.didSelectItem(feature: viewModel.feature)
        
    }
}
