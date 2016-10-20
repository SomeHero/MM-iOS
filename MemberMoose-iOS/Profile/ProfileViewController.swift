//
//  ProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ALTextInputBar

@objc protocol DataSourceItemProtocol {
    func viewForHeader() -> UIView?
    func heightForHeader() -> CGFloat
    func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
}
@objc protocol DataSourceTableViewCellProtocol: class {
    func setupWith(viewModel: DataSourceItemProtocol)
}
protocol ProfileDelegate: class {
    func didBackClicked()
}
enum ProfileType {
    case bull
    case calf
}
class ProfileViewController: UIViewController {
    private let user: User
    private let profileType: ProfileType
    private let calfProfileCellIdentifier       = "CalfProfileHeaderCellIdentifier"
    private let profileCellIdentifier           = "ProfileHeaderCellIdentifier"
    private let cellIdentifier                  = "SubscriptionCellIdentifier"
    private let paymentCardCellIdentifier       = "PaymentCardCellIdentifier"
    private let paymentHistoryCellIdentifier       = "PaymentHistoryCellIdentifier"
    private let chargeCellIdentifier            = "ChargeCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private var memberNavigationState: MemberNavigationState = .Profile
    private let textInputBar = ALTextInputBar()
    weak var profileDelegate: ProfileDelegate?
    
    private let offsetNavHeaderHeight: CGFloat = 64.0
    private let offsetLabelHeaderHeight: CGFloat = 32.0
    private let labelHeaderAdditionalOffset: CGFloat = 6.0
    private let chromeAnimationDuration: NSTimeInterval = 0.2
    private let verticalNavHeaderOffset: CGFloat = 12.0
    private let menuButtonWidth: CGFloat = 26.0
    private let nonNavBarMenuButtonVerticalOffset: CGFloat = 20.0;
    private let nonNavBarMenuButtonHorizontalOffset: CGFloat = 12.0;
    private var chromeVisible = true
    
    private var scrollDarkNavDelayFactor:CGFloat {
        return 1.3
    }
    private var parallaxHeight: CGFloat {
        //values determined by the top padding of the title in the authed/unauth headers
        if tableView.visibleCells.count > 0 {
            return tableView.visibleCells[0].frame.size.height
        }
        
        return 0
    }
    private lazy var navHeader: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.clearColor()
        _view.clipsToBounds = true
        
        self.view.addSubview(_view)
        return _view
    }()
    private lazy var navHeaderDarkCoverView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColorTheme.Primary
        _view.alpha = 0
        
        self.navHeader.addSubview(_view)
        return _view
    }()
    private lazy var navHeaderLineView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.flatWhiteColor()
        
        self.navHeaderDarkCoverView.addSubview(_view)
        
        return _view
    }()
    private lazy var navHeaderNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold()
        _label.textColor = UIColor.whiteColor()
        _label.textAlignment = .Center
        
        self.navHeaderDarkCoverView.addSubview(_label)
        
        return _label
    }()
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
        _button.setImage(UIImage(named:"Edit"), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.editProfileClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
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
        _tableView.estimatedRowHeight   = self.tableCellHeight
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.contentInset         = UIEdgeInsetsZero
        
        _tableView.registerClass(ProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.registerClass(CalfProfileHeaderCell.self, forCellReuseIdentifier: self.calfProfileCellIdentifier)
        _tableView.registerClass(SubscriptionCell.self, forCellReuseIdentifier: self.cellIdentifier)
        _tableView.registerClass(PaymentCardTableViewCell.self, forCellReuseIdentifier: self.paymentCardCellIdentifier)
        _tableView.registerClass(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: self.paymentHistoryCellIdentifier)
        _tableView.registerClass(ChargeCell.self, forCellReuseIdentifier: self.chargeCellIdentifier)

        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch memberNavigationState {
            case .Message:
                return textInputBar
            default:
                return nil
            }
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    init(user: User, profileType: ProfileType) {
        self.user = user
        self.profileType = profileType
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .None
        automaticallyAdjustsScrollViewInsets = false
        
        title = "Profile"
        view.backgroundColor = .whiteColor()

        buildDataSet()

        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        tableView.snp_updateConstraints { (make) in
            make.edges.equalTo(view)
        }
        navHeader.snp_updateConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(offsetNavHeaderHeight)
        }
        navHeaderDarkCoverView.snp_updateConstraints { (make) in
            make.edges.equalTo(self.navHeader)
        }
        navHeaderNameLabel.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.navHeader)
            make.centerY.equalTo(self.navHeader).offset(verticalNavHeaderOffset)
            make.leading.trailing.equalTo(self.navHeader).inset(10*2+menuButtonWidth)
        }
        navHeaderLineView.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self.navHeader)
            make.height.equalTo(kOnePX*2)
            make.bottom.equalTo(self.navHeader.snp_bottom)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        switch profileType {
        case .bull:
            navHeaderNameLabel.text = user.companyName
        case .calf:
            if let firstName = user.firstName, lastName = user.lastName {
                navHeaderNameLabel.text = "\(firstName) \(lastName)"
            } else {
                navHeaderNameLabel.text = user.emailAddress
            }
        }
    }
    func backClicked(button: UIButton) {
        profileDelegate?.didBackClicked()
    }
    func editProfileClicked(button: UIButton) {
        switch profileType {
        case .bull:
            let viewController = BullProfileViewController(user: user)
            
            navigationController?.navigationBarHidden = false
            navigationController?.pushViewController(viewController, animated: true)
        case .calf:
            let viewController = UserProfileViewController(user: user, profileType: .bull)
            viewController.delegate = self
            
            navigationController?.navigationBarHidden = false
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        
        switch profileType {
        case .bull:
            let profileHeaderViewModel = ProfileHeaderViewModel(user: user)
            
            items.append([profileHeaderViewModel])
        case .calf:
            let calfProfileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            items.append([calfProfileHeaderViewModel])
        }
        
        switch memberNavigationState {
        case .Profile:
            var subscriptionViewModels: [SubscriptionViewModel] = []
            for membership in user.memberships {
                if let subscription = membership.subscription {
                    let subscriptionViewModel = SubscriptionViewModel(subscription: subscription)
                    subscriptionViewModels.append(subscriptionViewModel)
                }
            }
            items.append(subscriptionViewModels)
            
            var paymentCardViewModels: [PaymentCardViewModel] = []
            for paymentCard in user.paymentCards {
                let paymentCardViewModel = PaymentCardViewModel(paymentCard: paymentCard)
                
                paymentCardViewModels.append(paymentCardViewModel)
                
            }
            
            items.append(paymentCardViewModels)
            
            var paymentHistoryViewModels: [PaymentHistoryViewModel] = []
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            paymentHistoryViewModels.append(PaymentHistoryViewModel(transactionDate: NSDate(), transactionDescription: "Co-working 3 Day per week", cardDescription: "Discover Ending in 4242", amount: 30.00))
            items.append(paymentHistoryViewModels)
        case .Charge:
            let remainingHeight = view.frame.size.height - tableView.visibleCells[0].frame.size.height
            
            let viewModel = ChargeViewModel(totalCellHeight: remainingHeight)
            
            items.append([viewModel])
        default:
            break

        }
        dataSource = items
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        handleNavHeaderScrollingWithOffset(yOffset)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func handleNavHeaderScrollingWithOffset(yOffset: CGFloat) {
        if chromeVisible {
            navHeaderDarkCoverView.alpha = min(1.0, (yOffset * scrollDarkNavDelayFactor - parallaxHeight + offsetLabelHeaderHeight) *  0.01)
            
            let labelTransform = CATransform3DMakeTranslation(0, max(0.0, parallaxHeight - yOffset + labelHeaderAdditionalOffset), 0)
            navHeaderNameLabel.layer.transform = labelTransform
        }
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
        
            return view.viewForHeader()
        }
        
        return nil
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dataItems = dataSource[section]
        
        if dataItems.count > 0 {
            let view = dataItems[0]
            
            return view.heightForHeader()
        }
        
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}
extension ProfileViewController: UserProfileDelegate {
    func didClickBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}
extension ProfileViewController: MemberNavigationDelegate {
    func messageClicked() {
        memberNavigationState = .Message
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func profileClicked() {
        memberNavigationState = .Profile
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func chargeClicked() {
        memberNavigationState = .Charge
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
}
