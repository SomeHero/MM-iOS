//
//  ProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ALTextInputBar
import Presentr
import Stripe
import SVProgressHUD
import Money

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
    private let subscriptionCellIdentifier                  = "SubscriptionCellIdentifier"
    private let subscriptionEmptyStateCellIdentifier        = "SubscriptionEmptyStateCellIdentifier"
    private let paymentCardCellIdentifier       = "PaymentCardCellIdentifier"
    private let paymentCardEmptyStateCellIdentifier       = "PaymentCardEmptyStateCellIdentifier"
    private let paymentHistoryCellIdentifier       = "PaymentHistoryCellIdentifier"
    private let paymentHistoryEmptyStateCellIdentifier       = "PaymentHistoryEmptyStateCellIdentifier"
    private let chargeCellIdentifier            = "ChargeCellIdentifier"
    private let memberCellIdentifier            = "MemberCellIdentifier"
    private let memberEmptyStateCellIdentifier  = "MemberEmptyStateCellIdentifier"
    private let planCellIdentifier              = "PlanCellIdentifier"
    private let planEmptyStateCellIdentifier    = "PlanEmptyStateCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private var membershipNavigationState: MembershipNavigationState = .Members
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
    
    private var hasMembers = false
    private var hasPlans = false
    
    private var pageNumber = 1
    
    private var presenter: Presentr = {
        let _presenter = Presentr(presentationType: .Alert)
        _presenter.transitionType = .CoverVertical // Optional
        _presenter.presentationType = .Popup
        
        return _presenter
    }()
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
        if let navigationController = self.navigationController where navigationController.viewControllers.count > 1 {
            _button.setImage(UIImage(named:"Back-Reverse"), forState: .Normal)
        } else {
            _button.setImage(UIImage(named:"Menu"), forState: .Normal)
        }
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
        //_tableView.separatorStyle       = .None
        
        _tableView.registerClass(ProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.registerClass(CalfProfileHeaderCell.self, forCellReuseIdentifier: self.calfProfileCellIdentifier)
        _tableView.registerClass(SubscriptionCell.self, forCellReuseIdentifier: self.subscriptionCellIdentifier)
        _tableView.registerClass(SubscriptionEmptyStateCell.self, forCellReuseIdentifier: self.subscriptionEmptyStateCellIdentifier)
        _tableView.registerClass(PaymentCardTableViewCell.self, forCellReuseIdentifier: self.paymentCardCellIdentifier)
        _tableView.registerClass(PaymentCardEmptyStateCell.self, forCellReuseIdentifier: self.paymentCardEmptyStateCellIdentifier)
        _tableView.registerClass(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: self.paymentHistoryCellIdentifier)
        _tableView.registerClass(PaymentHistoryEmptyStateCell.self, forCellReuseIdentifier: self.paymentHistoryEmptyStateCellIdentifier)
        _tableView.registerClass(ChargeCell.self, forCellReuseIdentifier: self.chargeCellIdentifier)
        _tableView.registerClass(MemberCell.self, forCellReuseIdentifier: self.memberCellIdentifier)
        _tableView.registerClass(MemberEmptyStateCell.self, forCellReuseIdentifier: self.memberEmptyStateCellIdentifier)
        _tableView.registerClass(PlanCell.self, forCellReuseIdentifier: self.planCellIdentifier)
        _tableView.registerClass(PlanEmptyStateCell.self, forCellReuseIdentifier: self.planEmptyStateCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var addMemberButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("ADD MEMBER", forState: .Normal)
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.addMemberClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var addPlanButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("CREATE PLAN", forState: .Normal)
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.addPlanClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch profileType {
            case .bull:
                switch membershipNavigationState {
                case .Messages:
                    return textInputBar
                default:
                    return nil
                }
            case .calf:
                switch memberNavigationState {
                case .Message:
                    return textInputBar
                default:
                    return nil
                }
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

        configureRevealControllerGestures(view)
        configureRevealWidth()
        
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Set custom indicator margin
        self.tableView.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            guard let _self = self else {
                return
            }
            if _self.profileType == .calf {
                scrollView.finishInfiniteScroll()
                
                return
            }
            _self.pageNumber += 1
            
            switch _self.membershipNavigationState {
            case .Members:
                ApiManager.sharedInstance.getMembers(_self.pageNumber, success: { (members) in
                    var viewModels = _self.dataSource[1]
                    for member in members! {
                        let viewModel = MemberViewModel(user: member)
                        
                        viewModels.append(viewModel)
                    }
                    _self.dataSource[1] = viewModels
                    
                    _self.tableView.reloadData()
                    }, failure: {[weak self] (error, errorDictionary) in
                        SVProgressHUD.dismiss()
                        
                        guard let _self = self else {
                            return
                        }
                        
                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                })
            case .Plans:
                ApiManager.sharedInstance.getPlans(_self.pageNumber, success: { (plans) in
                    var viewModels = _self.dataSource[1]
                    for plan in plans! {
                        let viewModel = PlanViewModel(plan: plan)
                        
                        viewModels.append(viewModel)
                    }
                    _self.dataSource[1] = viewModels
                    
                    _self.tableView.reloadData()
                    }, failure: { [weak self] (error, errorDictionary) in
                        SVProgressHUD.dismiss()
                        
                        guard let _self = self else {
                            return
                        }
                        
                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                })
            case .Messages: break
            }
            
            scrollView.finishInfiniteScroll()
        }
        
        pageNumber = 1
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
        addMemberButton.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        addPlanButton.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        switch profileType {
        case .bull:
            switch membershipNavigationState {
            case .Members:
                var offset = 60
                var tableViewOffset = 0
                if hasMembers {
                    offset = 0
                    tableViewOffset = 60
                }
                addMemberButton.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(offset)
                }
                addPlanButton.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(60)
                }
                tableView.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(tableViewOffset)
                }
            case .Plans:
                var offset = 60
                var tableViewOffset = 0
                if hasPlans {
                    offset = 0
                    tableViewOffset = 60
                }
                addMemberButton.snp_updateConstraints(closure: { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(60)
                })
                addPlanButton.snp_updateConstraints(closure: { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(offset)
                })
                tableView.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(tableViewOffset)
                }
            default:
                addMemberButton.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(60)
                }
                addPlanButton.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view.snp_bottom).offset(60)
                }
                tableView.snp_updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(0)
                }
            }
        default:
            addMemberButton.snp_updateConstraints { (make) in
                make.bottom.equalTo(view.snp_bottom).offset(60)
            }
            addPlanButton.snp_updateConstraints { (make) in
                make.bottom.equalTo(view.snp_bottom).offset(60)
            }
            tableView.snp_updateConstraints { (make) in
                make.bottom.equalTo(view).inset(0)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        switch profileType {
        case .bull:
            navHeaderNameLabel.text = user.account?.companyName
        case .calf:
            if let firstName = user.firstName, lastName = user.lastName {
                navHeaderNameLabel.text = "\(firstName) \(lastName)"
            } else {
                navHeaderNameLabel.text = user.emailAddress
            }
        }
    }
    func backClicked(sender: UIButton) {
        switch profileType {
        case .bull:
            toggleMenu(sender)
        case .calf:
            navigationController?.popViewControllerAnimated(true)
        }
    }
    func editProfileClicked(button: UIButton) {
        switch profileType {
        case .bull:
            guard let account = user.account else {
                return
            }
            let viewController = AccountProfileViewController(account: account, profileType: .bull)
            viewController.delegate = self
            
            presentViewController(viewController, animated: true, completion: nil)
        case .calf:
            let viewController = UserProfileViewController(user: user, profileType: .bull)
            viewController.delegate = self
            
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        hasMembers = false
        hasPlans = false
        
        switch profileType {
        case .bull:
            let profileHeaderViewModel = ProfileHeaderViewModel(user: user, membershipNavigationState: membershipNavigationState, membershipNavigationDelegate: self)
            
            items.append([profileHeaderViewModel])
            
            switch membershipNavigationState {
            case .Members:
                    ApiManager.sharedInstance.getMembers(self.pageNumber, success: { [weak self] (members) in
                        guard let _self = self else {
                            return
                        }
                        if(members!.count > 0) {
                            _self.hasMembers = true
                            
                            var viewModels: [MemberViewModel] = []
                            for member in members! {
                                let viewModel = MemberViewModel(user: member)
                                
                                viewModels.append(viewModel)
                            }
                            items.append(viewModels)
                            
                            _self.dataSource = items
                        } else {
                            var viewModels: [MemberEmptyStateViewModel] = []
                            viewModels.append(MemberEmptyStateViewModel(logo: "Logo-DeadMoose", header: "804RVA has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.", memberEmptyStateDelegate: _self))
                            
                            items.append(viewModels)
                            _self.dataSource = items
                        }
                    }) { [weak self] (error, errorDictionary) in
                        SVProgressHUD.dismiss()
                        
                        guard let _self = self else {
                            return
                        }
                        
                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                }
            case .Plans:
                ApiManager.sharedInstance.getPlans(1, success: { [weak self] (plans) in
                    guard let _self = self else {
                        return
                    }
                    if(plans!.count > 0) {
                        _self.hasPlans = true
                        
                        var viewModels: [PlanViewModel] = []
                        for plan in plans! {
                            let viewModel = PlanViewModel(plan: plan)
                            
                            viewModels.append(viewModel)
                        }
                        items.append(viewModels)
                        
                        _self.dataSource = items
                    } else {
                        var viewModels: [PlanEmptyStateViewModel] = []
                        viewModels.append(PlanEmptyStateViewModel(logo: "Logo-DeadMoose", header: "804RVA has no plans!", subHeader: "The best way to add plans to your community is to create a plan manually or import existing plans from your Stripe account.", planEmptyStateDelgate: self))
                        
                        items.append(viewModels)
                        _self.dataSource = items
                    }
                }) { [weak self] (error, errorDictionary) in
                    SVProgressHUD.dismiss()
                    
                    guard let _self = self else {
                        return
                    }
                    
                    ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                }
            case .Messages:
                break
            }
        case .calf:
            let calfProfileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            items.append([calfProfileHeaderViewModel])
            
            switch memberNavigationState {
            case .Profile:
                if user.memberships.count > 0 {
                    var subscriptionViewModels: [SubscriptionViewModel] = []
                    for membership in user.memberships {
                        if let subscription = membership.subscription {
                            let subscriptionViewModel = SubscriptionViewModel(subscription: subscription, subscriptionDelegate: self)
                            subscriptionViewModels.append(subscriptionViewModel)
                        }
                    }
                    items.append(subscriptionViewModels)
                } else {
                    var subscriptionEmptyStateViewModels: [SubscriptionEmptyStateViewModel] = []
                    subscriptionEmptyStateViewModels.append(SubscriptionEmptyStateViewModel(header: "Not Subscribed to Any Plans", subscriptionEmptyStateDelegate: self))
                    
                    items.append(subscriptionEmptyStateViewModels)
                }
                
                if user.paymentCards.count > 0 {
                    var paymentCardViewModels: [PaymentCardViewModel] = []
                    for paymentCard in user.paymentCards {
                        let paymentCardViewModel = PaymentCardViewModel(paymentCard: paymentCard, paymentCardDelegate: self)
                        
                        paymentCardViewModels.append(paymentCardViewModel)
                    }
                    items.append(paymentCardViewModels)
                } else {
                    var paymentCardEmptyStateViewModels: [PaymentCardEmptyStateViewModel] = []
                    paymentCardEmptyStateViewModels.append(PaymentCardEmptyStateViewModel(header: "No Payment Card on File", paymentCardEmptyStateDelegate: self))
                    
                    items.append(paymentCardEmptyStateViewModels)
                }
                
                //
                if user.charges.count > 0 {
                    var paymentHistoryViewModels: [PaymentHistoryViewModel] = []
                    for charge in user.charges {
                        let paymentHistoryViewModel = PaymentHistoryViewModel(charge: charge)
                        
                        paymentHistoryViewModels.append(paymentHistoryViewModel)
                    }
                    items.append(paymentHistoryViewModels)
                } else {
                    var paymentHistoryEmptyStateViewModels: [PaymentHistoryEmptyStateViewModel] = []
                    paymentHistoryEmptyStateViewModels.append(PaymentHistoryEmptyStateViewModel(header: "No Transactions"))
                    
                    items.append(paymentHistoryEmptyStateViewModels)
                }
               
            case .Charge:
                let remainingHeight = view.frame.size.height - tableView.visibleCells[0].frame.size.height
                
                let viewModel = ChargeViewModel(totalCellHeight: remainingHeight, chargeCellDelegate: self)
                
                items.append([viewModel])
            default:
                break
                
            }
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
    func addPlanClicked(sender: UIButton) {
//        let viewController = PlanProfileViewController()
//        
//        navigationController?.pushViewController(viewController, animated: true)
    }
    func addMemberClicked(sender: UIButton) {
        let viewController = SharePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
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
        let viewModel = dataItems[indexPath.row]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let dataItems = dataSource[indexPath.section]
        
        switch profileType {
        case .calf:
            break
        case .bull:
            switch membershipNavigationState {
            case .Members:
                guard let viewModel = dataItems[indexPath.row] as? MemberViewModel else {
                    return
                }
                
                let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
                //viewController.profileDelegate = self
                
                navigationController?.pushViewController(viewController, animated: true)
                
            //profileType = .calf
            case .Plans:
                guard let viewModel = dataItems[indexPath.row] as? PlanViewModel else {
                    return
                }
                
                let viewController = PlanProfileViewController(plan: viewModel.plan)
                
                navigationController?.pushViewController(viewController, animated: true)
            case .Messages:
                break;
            }
        }
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
        dismissViewControllerAnimated(true, completion: nil)
    }
}
extension ProfileViewController: AccountProfileDelegate {
    func didAccountProfileClickBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
extension ProfileViewController: MemberNavigationDelegate {
    func messageClicked() {
        memberNavigationState = .Message
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func profileClicked() {
        memberNavigationState = .Profile
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func chargeClicked() {
        memberNavigationState = .Charge
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
}
extension ProfileViewController: MembershipNavigationDelegate {
    func membersClicked() {
        membershipNavigationState = .Members
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func plansClicked() {
        membershipNavigationState = .Plans
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func messagesClicked() {
        membershipNavigationState = .Messages
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
}
extension ProfileViewController: SubscriptionDelegate {
    func didCancelSubscription(subscription: Subscription) {
        print("cancel subscription")

        let controller = CancelSubscriptionViewController(subscription: subscription)
        controller.cancelSubscriptionDelegate = self
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    func didChangeSubscription(subscription: Subscription) {
        print("change subscription")
        let viewController = ChangePlansViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func didHoldSubscription(subscription: Subscription) {
        print("hold subscription")
    }
}
extension ProfileViewController: PaymentCardDelegate {
    func didUpdatePaymentCard(paymentCard: PaymentCard) {
        let viewController = CardIOViewController()
        viewController.cardCaptureDelegate = self

        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension ProfileViewController: CancelSubscriptionDelegate {
    func didClose() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func didConfirmCancelSubscription(subscription: Subscription) {
        ApiManager.sharedInstance.cancelSubscription(subscription.id, success: {
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error, errorDictionary) in
            print("error occurred")
        }
    }
}
extension ProfileViewController: MemberEmptyStateDelegate {
    func didCreateMember() {
        let viewController = AddMemberViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func didSharePlan() {
        let viewController = SharePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension ProfileViewController: PlanEmptyStateDelegate {
    func didCreatePlan() {
//        let viewController = PlanProfileViewController()
//        
//        navigationController?.pushViewController(viewController, animated: true)
    }
    func didImportPlan() {
        print("import plan")
    }
}
extension ProfileViewController: SubscriptionEmptyStateDelegate {
    func didSubscribe() {
        print("did subscribe")
    }
}
extension ProfileViewController: PaymentCardEmptyStateDelegate {
    func didAddPaymentCard() {
        let viewController = CardIOViewController()
        viewController.cardCaptureDelegate = self
        
        presentViewController(viewController, animated: true) { 
            viewController.scanCard()
        }
    }
}
extension ProfileViewController: CardCaptureDelegate {
    func didCancelCardCapture() {
        navigationController?.popViewControllerAnimated(true)
    }
    func didCompleteCardCapture(stpCard: STPCardParams) {
        dismissViewControllerAnimated(true, completion: {
            SVProgressHUD.show()
            STPAPIClient.sharedClient().createTokenWithCard(stpCard, completion: { [weak self] (token, error) in
                guard let _self = self else {
                    return
                }
                if let error = error {
                    SVProgressHUD.dismiss()
                    
                    ErrorHandler.presentErrorDialog(_self, error: error)
                } else if let token = token {
                    let addPaymentCard = AddPaymentCard(userId: _self.user.id, stripeToken: token.tokenId)
                    ApiManager.sharedInstance.addPaymentCard(addPaymentCard, success: { [weak self] (response) in
                        SVProgressHUD.dismiss()
                    
                        guard let _self = self else {
                            return
                        }
                        _self.user.paymentCards.append(response)
                        
                        _self.buildDataSet()
                    }, failure: { [weak self] (error, errorDictionary) in
                        guard let _self = self else {
                            return
                        }
                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                    })
                }
            })
        })
    }
}
extension ProfileViewController: ChargeCellDelegate {
    func didChargeAmount(amount: USD) {
        SVProgressHUD.show()
        
        let createCharge = CreateCharge(userId: user.id, amount: amount.floatValue, description: "Test Charge")
        
        ApiManager.sharedInstance.createCharge(createCharge, success: { [weak self] (response) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            _self.user.charges.append(response)
            
            _self.buildDataSet()
        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
}