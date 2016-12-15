//
//  ImportPlansViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController
import SVProgressHUD

class ImportPlansViewController: UIViewController {
    fileprivate let plansCellIdentifier                  = "ImportPlanCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    fileprivate let user:User
    
    var plans: [ImportPlanViewModel] = [] {
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
 
        _tableView.register(ImportPlanTableViewCell.self, forCellReuseIdentifier: self.plansCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var planCountLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(ImportPlansViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var noThanksButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.Link, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        
        _button.addTarget(self, action: #selector(ImportPlansViewController.skipClicked(_:)), for: .touchUpInside)
        
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
        
        title = "Import from Stripe"
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let skipButton = UIBarButtonItem(title: "SKIP", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(CreateFirstPlanViewController.skipClicked(_:)))
        navigationItem.rightBarButtonItem = skipButton
        
        setup()
        
        loadPlans()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(20)
            make.leading.trailing.equalTo(view)
        }
        planCountLabel.snp.updateConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp.updateConstraints { (make) in
            make.top.equalTo(planCountLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
        noThanksButton.snp.updateConstraints { (make) in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(10)
        }
    }
    func setup() {
        setPlanCountLabel()
        noThanksButton.setTitle("No Thanks", for: UIControlState())
    }
    func loadPlans() {
        guard let user = SessionManager.sharedUser, let account = user.account else {
            return
        }
        
        var viewModels: [ImportPlanViewModel] = []
        for plan in account.referencePlans {
            viewModels.append(ImportPlanViewModel(plan: plan))
        }
        plans = viewModels
    }
    func skipClicked(_ sender: UIButton) {
        let viewController = ProfileViewController(user: user, profileType: .bull)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        
        let menuViewController = MenuViewController()
        
        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.swRevealViewController = swRevealViewController
            
            delegate.window?.rootViewController?.present(swRevealViewController!, animated: true, completion: nil)
        }
    }
    func nextClicked(_ sender: UIButton) {
        guard let user = SessionManager.sharedUser, let userId = user.id else {
            return
        }
        SVProgressHUD.show()
        
        var plansList: [String] = []
        for viewModel in plans {
            if viewModel.selected {
                plansList.append(viewModel.plan.referenceId)
            }
        }
        
        ApiManager.sharedInstance.importPlans(userId, plansList: plansList, success: { (response) in
            SVProgressHUD.dismiss()
            
            SessionManager.sharedUser = response
            SessionManager.persistUser()
            
            let viewController = ProfileViewController(user: user, profileType: .bull)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = true
            
            let menuViewController = MenuViewController()
            
            let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.swRevealViewController = swRevealViewController
                
                delegate.window?.rootViewController?.present(swRevealViewController!, animated: true, completion: nil)
            }
        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
    func setPlanCountLabel() {
        var count = 0
        for viewModel in plans {
            if viewModel.selected {
                count += 1
            }
        }
        if(count == 0) {
            planCountLabel.text = "No Plans Selected"
        } else {
            planCountLabel.text = "Import \(count) Plans"
        }
    }
}

extension ImportPlansViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = plans[(indexPath as NSIndexPath).item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.setupWith(viewModel)
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ImportPlansViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = plans[(indexPath as NSIndexPath).item]
        
        viewModel.selected = !viewModel.selected
        
        setPlanCountLabel()
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
