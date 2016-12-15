//
//  MemberMenuViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/15/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

enum MemberMenuItems: Int, Printable {
    case changePassword = 0
    case message = 1
    case oneTimePaymentRequest = 2
    case subscribe = 3
    
    static let allValues = [changePassword, message, oneTimePaymentRequest, subscribe]
    
    var description: String {
        switch self {
        case .message: return "Message"
        case .subscribe   : return "Subscribe"
        case .oneTimePaymentRequest  : return "One Time Payment"
        case .changePassword  : return "Change Password"
        }
    }
}
class MemberMenuViewController: UIViewController {
    fileprivate let user: User
    weak var planProfileDelegate: PlanProfileDelegate?
    
    fileprivate let menuHeaderCellIdentifier        = "MenuHeaderCellIdentifier"
    fileprivate let menuItemCellIdentifier          = "MenuItemCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.white
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsets.zero
        _tableView.layoutMargins        = UIEdgeInsets.zero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = self.tableCellHeight
        
        _tableView.register(MenuHeaderCell.self, forCellReuseIdentifier: self.menuHeaderCellIdentifier)
        _tableView.register(MenuItemCell.self, forCellReuseIdentifier: self.menuItemCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var signOutButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("Sign Out", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(MenuViewController.signOutClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let user = SessionManager.sharedUser else {
            return
        }
        //        let headerViewModel = MenuHeaderViewModel(user: user, menuHeaderDelegate: self)
        //        dataSource.append([headerViewModel])
        //
        var viewModels: [MenuItemViewModel] = []
        for menuItem in MemberMenuItems.allValues {
            viewModels.append(MenuItemViewModel(title: menuItem.description))
        }
        dataSource.append(viewModels)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MemberMenuViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItems = dataSource[section]
        
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        let viewModel = dataItems[(indexPath as NSIndexPath).item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension MemberMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let dataItems = dataSource[(indexPath as NSIndexPath).section]
//        
//        switch indexPath.row {
//        case PlanMenuItems.previewPlan.rawValue:
//            let previewPlanViewController = PreviewPlanViewController(plan: plan)
//            let navigationViewController = UINavigationController(rootViewController: previewPlanViewController)
//            
//            present(navigationViewController, animated: true, completion: nil)
//        case PlanMenuItems.sharePlan.rawValue:
//            let sharePlanViewController = SharePlanViewController(plan: plan)
//            let navigationViewController = UINavigationController(rootViewController: sharePlanViewController)
//            
//            present(navigationViewController, animated: true, completion: nil)
//        case PlanMenuItems.deletePlan.rawValue:
//            let deletePlanViewController = DeletePlanViewController(plan: plan)
//            deletePlanViewController.planProfileDelegate = planProfileDelegate
//            
//            let navigationViewController = UINavigationController(rootViewController: deletePlanViewController)
//            
//            present(navigationViewController, animated: true, completion: nil)
//        default:
//            print("nothing happened??")
//        }
    }
}
