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
    private let plansCellIdentifier                  = "ImportPlanCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private let user:User
    
    var plans: [ImportPlanViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.whiteColor()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsetsZero
        _tableView.layoutMargins        = UIEdgeInsetsZero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = self.tableCellHeight
 
        _tableView.registerClass(ImportPlanTableViewCell.self, forCellReuseIdentifier: self.plansCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var planCountLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(ImportPlansViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var noThanksButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.Link, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        _button.addTarget(self, action: #selector(ImportPlansViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
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
        view.backgroundColor = .whiteColor()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let skipButton = UIBarButtonItem(title: "SKIP", style: UIBarButtonItemStyle.Plain, target: self, action:  #selector(CreateFirstPlanViewController.skipClicked(_:)))
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
        
        tableView.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(20)
            make.leading.trailing.equalTo(view)
        }
        planCountLabel.snp_updateConstraints { (make) in
            make.top.equalTo(tableView.snp_bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        nextButton.snp_updateConstraints { (make) in
            make.top.equalTo(planCountLabel.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
        noThanksButton.snp_updateConstraints { (make) in
            make.top.equalTo(nextButton.snp_bottom).offset(10)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(10)
        }
    }
    func setup() {
        setPlanCountLabel()
        noThanksButton.setTitle("No Thanks", forState: .Normal)
    }
    func loadPlans() {
        guard let user = SessionManager.sharedUser, account = user.account else {
            return
        }
        
        var viewModels: [ImportPlanViewModel] = []
        for plan in account.referencePlans {
            viewModels.append(ImportPlanViewModel(plan: plan))
        }
        plans = viewModels
    }
    func skipClicked(sender: UIButton) {
        let viewController = ProfileViewController(user: user, profileType: .bull)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBarHidden = true
        
        let menuViewController = MenuViewController()
        
        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.swRevealViewController = swRevealViewController
            
            delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
        }
    }
    func nextClicked(sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        SVProgressHUD.show()
        
        var plansList: [String] = []
        for viewModel in plans {
            if viewModel.selected {
                plansList.append(viewModel.plan.referenceId)
            }
        }
        
        ApiManager.sharedInstance.importPlans(user.id, plansList: plansList, success: { (response) in
            SVProgressHUD.dismiss()
            
            SessionManager.sharedUser = response
            SessionManager.persistUser()
            
            let viewController = ProfileViewController(user: user, profileType: .bull)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBarHidden = true
            
            let menuViewController = MenuViewController()
            
            let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
            
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.swRevealViewController = swRevealViewController
                
                delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = plans[indexPath.item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.setupWith(viewModel)
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ImportPlansViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let viewModel = plans[indexPath.item]
        
        viewModel.selected = !viewModel.selected
        
        setPlanCountLabel()
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
}
