//
//  RecentTransactionsViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ChameleonFramework

class RecentTransactionsViewController: UIViewController {
    private let cellIdentifier                  = "RecentTransactionCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    
    var transactions: [RecentTransactionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.flatWhiteColor()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsetsZero
        _tableView.layoutMargins        = UIEdgeInsetsZero
        _tableView.tableFooterView      = UIView()
        _tableView.rowHeight            = self.tableCellHeight
        
        _tableView.registerClass(MemberCell.self, forCellReuseIdentifier: self.cellIdentifier)
        _tableView.addSubview(self.emptyState)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var emptyState: EmptyStateView = {
        let _emptyState = EmptyStateView()
        _emptyState.alpha = 0.0
        _emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        return _emptyState
    }()
    private lazy var menuButton: UIButton = {
       let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), forState: .Normal)
        _button.addTarget(self, action: #selector(RecentTransactionsViewController.toggleMenu(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var topBackgroundView: UIView = {
       let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    private lazy var companyNameLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .whiteColor()
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.topBackgroundView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.topBackgroundView.addSubview(_label)
        
        return _label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        setup()
        
        emptyState.alpha = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        topBackgroundView.snp_updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        companyNameLabel.snp_updateConstraints { (make) in
            make.top.equalTo(topBackgroundView).inset(20)
            make.centerX.equalTo(topBackgroundView)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp_bottom)
            make.centerX.equalTo(topBackgroundView)
        }
        tableView.snp_updateConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp_bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }
        emptyState.snp_updateConstraints { make in
            make.edges.equalTo(view)
        }
    }
    func setup() {
        companyNameLabel.text = "804RVA"
        subHeadingLabel.text = "Cashflow"
        emptyState.setup("No Recent Transactions.", message: "You have no recent transactions :(")
        
    }
}


extension RecentTransactionsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell      = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? RecentTransactionCell else {
            //HandleError(.Fatal(message: "Unable to find SeleMarketCell in dequeue", function: #function))
            
            return UITableViewCell()
        }
        let viewModel = transactions[indexPath.item]
        
        //cell.setupWith(viewModel)
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension RecentTransactionsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let viewModel = transactions[indexPath.item]
    }
}