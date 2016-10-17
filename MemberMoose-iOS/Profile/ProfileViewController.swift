//
//  ProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

@objc protocol DataSourceItemProtocol {
    func viewForHeader() -> UIView
    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
}
@objc protocol DataSourceTableViewCellProtocol: class {
    func setupWith(viewModel: DataSourceItemProtocol)
}

class ProfileViewController: UIViewController {
    private let cellIdentifier                  = "SubscriptionCellIdentifier"
    private let paymentCardCellIdentifier       = "PaymentCardCellIdentifier"
    private let paymentHistoryCellIdentifier       = "PaymentHistoryCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
   
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.whiteColor().CGColor
        _imageView.layer.borderWidth = 2.0
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var companyNameLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .whiteColor()
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView(frame: CGRect.zero, style: .Grouped)
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.whiteColor()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsetsZero
        _tableView.layoutMargins        = UIEdgeInsetsZero
        _tableView.tableFooterView      = UIView()
        _tableView.rowHeight            = self.tableCellHeight
        _tableView.contentInset         = UIEdgeInsetsZero
        
        _tableView.registerClass(SubscriptionCell.self, forCellReuseIdentifier: self.cellIdentifier)
        _tableView.registerClass(PaymentCardTableViewCell.self, forCellReuseIdentifier: self.paymentCardCellIdentifier)
        _tableView.registerClass(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: self.paymentHistoryCellIdentifier)
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
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        buildDataSet()
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBackgroundView.snp_updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        settingsButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        containerView.snp_updateConstraints { (make) in
            make.centerX.centerY.equalTo(topBackgroundView)
            make.bottom.equalTo(topBackgroundView).inset(20)
        }
        logo.snp_updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        companyNameLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp_bottom)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            logo.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                    placeholderImage: UIImage(named: "MissingAvatar-Bull"))
        } else {
            logo.image = UIImage(named: "MissingAvatar-Bull")
        }
        companyNameLabel.text = user.companyName
        subHeadingLabel.text = "Member Since Jan 2015"
        
        emptyState.setup("No Subscriptions.", message: "No Subscriptions")
        
    }
    func backClicked(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func showProfile(button: UIButton) {
        
    }
    func buildDataSet() {
        var subscriptionViewModels: [SubscriptionViewModel] = []
        let subscriptionViewModel = SubscriptionViewModel(planName: "Membermoose Prime", planAmount: "$30.00/monthly", status: "Active")
        subscriptionViewModels.append(subscriptionViewModel)
        
        dataSource.append(subscriptionViewModels)
        
        var paymentCardViewModels: [PaymentCardViewModel] = []
        let paymentCardViewModel = PaymentCardViewModel(nameOnCard: "James Rhodes", cardDescription: "Discover Ending in 4242", cardExpiration: "Expiration: 4/2020")
        paymentCardViewModels.append(paymentCardViewModel)
        
        dataSource.append(paymentCardViewModels)
        
        var paymentHistoryViewModels: [PaymentHistoryViewModel] = []
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
        
        dataSource.append(paymentHistoryViewModels)
    }

}
extension ProfileViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItems = dataSource[section]
        
        return dataItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataItems = dataSource[indexPath.section]
        let viewModel = dataItems[indexPath.item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataItems = dataSource[indexPath.section]
        let viewModel = dataItems[indexPath.item]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let viewController = MemberDetailViewController()
        
        //navigationController?.pushViewController(viewController, animated: true)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
        
            return view.viewForHeader()
        }
        
        return nil
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}
