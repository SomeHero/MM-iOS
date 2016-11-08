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
    fileprivate let cellIdentifier                  = "RecentTransactionCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    
    var transactions: [RecentTransactionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.flatWhite()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsets.zero
        _tableView.layoutMargins        = UIEdgeInsets.zero
        _tableView.tableFooterView      = UIView()
        _tableView.rowHeight            = self.tableCellHeight
        
        _tableView.register(MemberCell.self, forCellReuseIdentifier: self.cellIdentifier)
        _tableView.addSubview(self.emptyState)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var emptyState: EmptyStateView = {
        let _emptyState = EmptyStateView()
        _emptyState.alpha = 0.0
        _emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        return _emptyState
    }()
    fileprivate lazy var menuButton: UIButton = {
       let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), for: UIControlState())
        _button.addTarget(self, action: #selector(RecentTransactionsViewController.toggleMenu(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var topBackgroundView: UIView = {
       let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var companyNameLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .white
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.topBackgroundView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.topBackgroundView.addSubview(_label)
        
        return _label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup()
        
        emptyState.alpha = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        topBackgroundView.snp.updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        companyNameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(topBackgroundView).inset(20)
            make.centerX.equalTo(topBackgroundView)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp.bottom)
            make.centerX.equalTo(topBackgroundView)
        }
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        emptyState.snp.updateConstraints { make in
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell      = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecentTransactionCell else {
            //HandleError(.Fatal(message: "Unable to find SeleMarketCell in dequeue", function: #function))
            
            return UITableViewCell()
        }
        let viewModel = transactions[(indexPath as NSIndexPath).item]
        
        //cell.setupWith(viewModel)
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension RecentTransactionsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = transactions[(indexPath as NSIndexPath).item]
    }
}
