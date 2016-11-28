//
//  ChangePlansViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ChangePlanDelegate: class {
    func didCompleteChangePlan(subscription: Subscription)
}
class ChangePlansViewController: UIViewController {
    fileprivate let tableCellHeight: CGFloat        = 120
    
    fileprivate var selectedIndexPath: IndexPath?
    
    let user: User
    let subscription: Subscription
    weak var changePlanDelegate: ChangePlanDelegate?
    
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
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
        
        _tableView.register(CurrentPlanCell.self, forCellReuseIdentifier: CurrentPlanViewModel.cellID)
        _tableView.register(NewPlanCell.self, forCellReuseIdentifier:  NewPlanViewModel.cellID)

        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var submitButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("CHANGE PLAN", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(ChangePlansViewController.changePlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    init(user: User, subscription: Subscription) {
        self.user = user
        self.subscription = subscription
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = "Upgrade/Downgrade"
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        ApiManager.sharedInstance.getPlans(success: { [weak self] (plans) in
            guard let _self = self else {
                return
            }
            var items: [[DataSourceItemProtocol]] = []
            
            let currentPlanViewModel = CurrentPlanViewModel(plan: _self.subscription.plan)
            items.append([currentPlanViewModel])
            
            var newPlanViewModels: [DataSourceItemProtocol] = []
            
            for plan in plans.filter({ $0.id != _self.subscription.plan.id }) {
                newPlanViewModels.append(NewPlanViewModel(plan: plan))
            }
            items.append(newPlanViewModels)
            
            _self.dataSource = items
        }, failure: { [weak self] (error, errorDictionary) in
            guard let _self = self else {
                return
            }
            ErrorHandler.presentErrorDialog(_self)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.updateConstraints { (make) in
            make.leading.trailing.top.equalTo(view)
        }
        submitButton.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changePlanClicked(_ sender: UIButton) {
        guard let selectedIndexPath = selectedIndexPath, let selectedPlan = dataSource[selectedIndexPath.section][selectedIndexPath.row] as? NewPlanViewModel else {
            return
        }
        print(selectedPlan.plan.name)
        
        let upgradeSubscription = UpgradeSubscription(planId: selectedPlan.plan.id)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.upgradeSubscription(user.id, subscription.id, upgradeSubscription, success: { [weak self] (new_subscription) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }

            _self.changePlanDelegate?.didCompleteChangePlan(subscription: new_subscription)
        }, failure: { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        });
    }
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension ChangePlansViewController: UITableViewDataSource {
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
extension ChangePlansViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath != indexPath, let viewModel = dataSource[selectedIndexPath.section][selectedIndexPath.row] as? NewPlanViewModel {
            viewModel.selected = false
            
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        selectedIndexPath = nil
        
        if let viewModel = dataSource[indexPath.section][indexPath.row] as? NewPlanViewModel {
            viewModel.selected = !viewModel.selected
            
            if(viewModel.selected) {
                selectedIndexPath = indexPath
            } else {
                selectedIndexPath = nil
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
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
