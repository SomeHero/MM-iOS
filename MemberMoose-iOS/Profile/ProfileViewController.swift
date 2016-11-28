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
import SlackTextViewController

@objc protocol DataSourceItemProtocol {
    func viewForHeader() -> UIView?
    func heightForHeader() -> CGFloat
    func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
@objc protocol DataSourceTableViewCellProtocol: class {
    func setupWith(_ viewModel: DataSourceItemProtocol)
}
protocol ProfileDelegate: class {
    func didBackClicked()
}
enum ProfileType {
    case bull
    case calf
}
class ProfileViewController: UIViewController {
    fileprivate let user: User
    fileprivate let profileType: ProfileType
    fileprivate let calfProfileCellIdentifier       = "CalfProfileHeaderCellIdentifier"
    fileprivate let profileCellIdentifier           = "ProfileHeaderCellIdentifier"
    fileprivate let subscriptionCellIdentifier                  = "SubscriptionCellIdentifier"
    fileprivate let subscriptionEmptyStateCellIdentifier        = "SubscriptionEmptyStateCellIdentifier"
    fileprivate let paymentCardCellIdentifier       = "PaymentCardCellIdentifier"
    fileprivate let paymentCardEmptyStateCellIdentifier       = "PaymentCardEmptyStateCellIdentifier"
    fileprivate let paymentHistoryCellIdentifier       = "PaymentHistoryCellIdentifier"
    fileprivate let paymentHistoryEmptyStateCellIdentifier       = "PaymentHistoryEmptyStateCellIdentifier"
    fileprivate let chargeCellIdentifier            = "ChargeCellIdentifier"
    fileprivate let messagesCellIdentifier          = "MessagesCellIdentifier"
    fileprivate let messagesEmptyStateCellIdentifier          = "MessagesEmptyStateCellIdentifier"
    fileprivate let memberCellIdentifier            = "MemberCellIdentifier"
    fileprivate let memberEmptyStateCellIdentifier  = "MemberEmptyStateCellIdentifier"
    fileprivate let planCellIdentifier              = "PlanCellIdentifier"
    fileprivate let planEmptyStateCellIdentifier    = "PlanEmptyStateCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    fileprivate var membershipNavigationState: MembershipNavigationState = .members
    fileprivate var memberNavigationState: MemberNavigationState = .profile
    fileprivate let textInputBar = SLKTextInputbar()
    
    weak var profileDelegate: ProfileDelegate?
    
    fileprivate let offsetNavHeaderHeight: CGFloat = 64.0
    fileprivate let offsetLabelHeaderHeight: CGFloat = 32.0
    fileprivate let labelHeaderAdditionalOffset: CGFloat = 6.0
    fileprivate let chromeAnimationDuration: TimeInterval = 0.2
    fileprivate let verticalNavHeaderOffset: CGFloat = 12.0
    fileprivate let menuButtonWidth: CGFloat = 26.0
    fileprivate let nonNavBarMenuButtonVerticalOffset: CGFloat = 20.0;
    fileprivate let nonNavBarMenuButtonHorizontalOffset: CGFloat = 12.0;
    fileprivate var chromeVisible = true
    
    fileprivate var hasMembers = false
    fileprivate var hasPlans = false
    
    fileprivate var pageNumber = 1
    
    fileprivate var presenter: Presentr = {
        let _presenter = Presentr(presentationType: .alert)
        _presenter.transitionType = .coverVertical // Optional
        _presenter.presentationType = .popup
        
        return _presenter
    }()
    fileprivate var scrollDarkNavDelayFactor:CGFloat {
        return 1.3
    }
    fileprivate var parallaxHeight: CGFloat {
        //values determined by the top padding of the title in the authed/unauth headers
        if tableView.visibleCells.count > 0 {
            return tableView.visibleCells[0].frame.size.height
        }
        
        return 0
    }
    fileprivate lazy var navHeader: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.clear
        _view.clipsToBounds = true
        
        self.view.addSubview(_view)
        return _view
    }()
    fileprivate lazy var navHeaderDarkCoverView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColorTheme.Primary
        _view.alpha = 0
        
        self.navHeader.addSubview(_view)
        return _view
    }()
    fileprivate lazy var navHeaderLineView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.flatWhite()
        
        self.navHeaderDarkCoverView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var navHeaderNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold()
        _label.textColor = UIColor.white
        _label.textAlignment = .center
        
        self.navHeaderDarkCoverView.addSubview(_label)
        
        return _label
    }()
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        if let navigationController = self.navigationController , navigationController.viewControllers.count > 1 {
            _button.setImage(UIImage(named:"Back-Reverse"), for: UIControlState())
        } else {
            _button.setImage(UIImage(named:"Menu"), for: UIControlState())
        }
        _button.addTarget(self, action: #selector(ProfileViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Edit"), for: UIControlState())
        _button.addTarget(self, action: #selector(ProfileViewController.editProfileClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var tableView: UITableView = {
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
        
        _tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.register(CalfProfileHeaderCell.self, forCellReuseIdentifier: self.calfProfileCellIdentifier)
        _tableView.register(SubscriptionCell.self, forCellReuseIdentifier: self.subscriptionCellIdentifier)
        _tableView.register(SubscriptionEmptyStateCell.self, forCellReuseIdentifier: self.subscriptionEmptyStateCellIdentifier)
        _tableView.register(PaymentCardTableViewCell.self, forCellReuseIdentifier: self.paymentCardCellIdentifier)
        _tableView.register(PaymentCardEmptyStateCell.self, forCellReuseIdentifier: self.paymentCardEmptyStateCellIdentifier)
        _tableView.register(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: self.paymentHistoryCellIdentifier)
        _tableView.register(PaymentHistoryEmptyStateCell.self, forCellReuseIdentifier: self.paymentHistoryEmptyStateCellIdentifier)
        _tableView.register(ChargeCell.self, forCellReuseIdentifier: self.chargeCellIdentifier)
        _tableView.register(MessagesCell.self, forCellReuseIdentifier: self.messagesCellIdentifier)
        _tableView.register(MessagesEmptyStateCell.self, forCellReuseIdentifier: self.messagesEmptyStateCellIdentifier)
        _tableView.register(MemberCell.self, forCellReuseIdentifier: self.memberCellIdentifier)
        _tableView.register(MemberEmptyStateCell.self, forCellReuseIdentifier: self.memberEmptyStateCellIdentifier)
        _tableView.register(PlanCell.self, forCellReuseIdentifier: self.planCellIdentifier)
        _tableView.register(PlanEmptyStateCell.self, forCellReuseIdentifier: self.planEmptyStateCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var addMemberButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("ADD MEMBER", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(ProfileViewController.addMemberClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var addPlanButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("CREATE PLAN", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(ProfileViewController.addPlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch profileType {
            case .bull:
                switch membershipNavigationState {
                case .messages:
                    return textInputBar
                default:
                    return nil
                }
            case .calf:
                switch memberNavigationState {
                case .message:
                    return textInputBar
                default:
                    return nil
                }
            }
        }
    }
    override var canBecomeFirstResponder : Bool {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        
        title = "Profile"
        view.backgroundColor = .white

        configureRevealControllerGestures(view)
        configureRevealWidth()
        
        self.tableView.infiniteScrollIndicatorStyle = .gray
        
        // Set custom indicator margin
        self.tableView.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScroll { [weak self] (scrollView) -> Void in
            guard let _self = self else {
                return
            }
            if _self.profileType == .calf {
                scrollView.finishInfiniteScroll()
                
                return
            }
            _self.pageNumber += 1
            
            switch _self.membershipNavigationState {
            case .members:
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
            case .plans:
                ApiManager.sharedInstance.getPlans(_self.pageNumber, success: { (plans) in
                    var viewModels = _self.dataSource[1]
                    for plan in plans {
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
            case .messages: break
            }
            
            scrollView.finishInfiniteScroll()
        }
        
        pageNumber = 1
        buildDataSet()

        setup()
    }
    override func viewDidLayoutSubviews() {
        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        settingsButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        tableView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
        }
        navHeader.snp.updateConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(offsetNavHeaderHeight)
        }
        navHeaderDarkCoverView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.navHeader)
        }
        navHeaderNameLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.navHeader)
            make.centerY.equalTo(self.navHeader).offset(verticalNavHeaderOffset)
            make.leading.trailing.equalTo(self.navHeader).inset(10*2+menuButtonWidth)
        }
        navHeaderLineView.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.navHeader)
            make.height.equalTo(kOnePX*2)
           
            make.bottom.equalTo(self.navHeader.snp.bottom)
        }
        addMemberButton.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(60)
            make.bottom.equalTo(view)
        }
        addPlanButton.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(60)
            make.bottom.equalTo(view)
        }
        switch profileType {
        case .bull:
            switch membershipNavigationState {
            case .members:
                var offset = 60
                var tableViewOffset = 0
                if hasMembers {
                    offset = 0
                    tableViewOffset = 60
                }
                addMemberButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(offset)
                }
                addPlanButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(60)
                }
                tableView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(tableViewOffset)
                }
            case .plans:
                var offset = 60
                var tableViewOffset = 0
                if hasPlans {
                    offset = 0
                    tableViewOffset = 60
                }
                addMemberButton.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(60)
                })
                addPlanButton.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(offset)
                })
                tableView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(tableViewOffset)
                }
            default:
                addMemberButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(60)
                }
                addPlanButton.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view.snp.bottom).offset(60)
                }
                tableView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(view).inset(0)
                }
            }
        default:
            addMemberButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(60)
            }
            addPlanButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(60)
            }
            tableView.snp.updateConstraints { (make) in
                make.bottom.equalTo(view).inset(0)
            }
        }
        
        super.viewDidLayoutSubviews()
        
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
            if let firstName = user.firstName, let lastName = user.lastName {
                navHeaderNameLabel.text = "\(firstName) \(lastName)"
            } else {
                navHeaderNameLabel.text = user.emailAddress
            }
        }
    }
    func backClicked(_ sender: UIButton) {
        switch profileType {
        case .bull:
            toggleMenu(sender)
        case .calf:
            navigationController?.popViewController(animated: true)
        }
    }
    func editProfileClicked(_ button: UIButton) {
        switch profileType {
        case .bull:
            guard let account = user.account else {
                return
            }
            let viewController = AccountProfileViewController(account: account, profileType: .bull)
            viewController.delegate = self
            
            present(viewController, animated: true, completion: nil)
        case .calf:
            let viewController = UserProfileViewController(user: user, profileType: .bull)
            viewController.delegate = self
            
            present(viewController, animated: true, completion: nil)
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
            case .members:
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
                            guard let account = _self.user.account else {
                                return
                            }
                            
                            var viewModels: [MemberEmptyStateViewModel] = []
                            viewModels.append(MemberEmptyStateViewModel(logo: "Logo-DeadMoose", header: "\(account.companyName!) has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.", memberEmptyStateDelegate: _self))
                            
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
            case .plans:
                ApiManager.sharedInstance.getPlans(1, success: { [weak self] (plans) in
                    guard let _self = self else {
                        return
                    }
                    if(plans.count > 0) {
                        _self.hasPlans = true
                        
                        var viewModels: [PlanViewModel] = []
                        for plan in plans {
                            let viewModel = PlanViewModel(plan: plan)
                            
                            viewModels.append(viewModel)
                        }
                        items.append(viewModels)
                        
                        _self.dataSource = items
                    } else {
                        guard let account = _self.user.account else {
                            return
                        }
                        var viewModels: [PlanEmptyStateViewModel] = []
                        viewModels.append(PlanEmptyStateViewModel(logo: "Logo-DeadMoose", header: "\(account.companyName!) has no plans!", subHeader: "The best way to add plans to your community is to create a plan manually or import existing plans from your Stripe account.", planEmptyStateDelgate: self))
                        
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
            case .messages:
                let remainingHeight = view.frame.size.height - tableView.visibleCells[0].frame.size.height
                
                var viewModels: [MessagesViewModel] = []
                viewModels.append(MessagesViewModel(totalCellHeight: remainingHeight, messages: [], messageViewDelegate: self))
                
                items.append(viewModels)
                break
            }
        case .calf:
            let calfProfileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            items.append([calfProfileHeaderViewModel])
            
            switch memberNavigationState {
            case .message:
                let remainingHeight = view.frame.size.height - tableView.visibleCells[0].frame.size.height

                ApiManager.sharedInstance.getMessages(user, self.pageNumber, success: { [weak self] (messages) in
                    guard let _self = self, let messages = messages else {
                        return
                    }
                    var viewModels: [MessagesViewModel] = []
                    viewModels.append(MessagesViewModel(totalCellHeight: remainingHeight, messages: messages, messageViewDelegate: self))
                    items.append(viewModels)
                        
                    _self.dataSource = items
                }) { [weak self] (error, errorDictionary) in
                    SVProgressHUD.dismiss()
                    
                    guard let _self = self else {
                        return
                    }
                    
                    ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                }
            case .profile:
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
               
            case .charge:
                let remainingHeight = view.frame.size.height - tableView.visibleCells[0].frame.size.height
                
                let viewModel = ChargeViewModel(totalCellHeight: remainingHeight, chargeCellDelegate: self)
                
                items.append([viewModel])
            default:
                break
                
            }
        }
        
        dataSource = items
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        handleNavHeaderScrollingWithOffset(yOffset)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    func handleNavHeaderScrollingWithOffset(_ yOffset: CGFloat) {
        if chromeVisible {
            navHeaderDarkCoverView.alpha = min(1.0, (yOffset * scrollDarkNavDelayFactor - parallaxHeight + offsetLabelHeaderHeight) *  0.01)
            
            let labelTransform = CATransform3DMakeTranslation(0, max(0.0, parallaxHeight - yOffset + labelHeaderAdditionalOffset), 0)
            navHeaderNameLabel.layer.transform = labelTransform
        }
    }
    func addPlanClicked(_ sender: UIButton) {
//        let viewController = PlanProfileViewController()
//        
//        navigationController?.pushViewController(viewController, animated: true)
    }
    func addMemberClicked(_ sender: UIButton) {
        let viewController = SharePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension ProfileViewController : UITableViewDataSource {
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

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        
        switch profileType {
        case .calf:
            break
        case .bull:
            switch membershipNavigationState {
            case .members:
                guard let viewModel = dataItems[(indexPath as NSIndexPath).row] as? MemberViewModel else {
                    return
                }
                
                let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
                //viewController.profileDelegate = self
                
                navigationController?.pushViewController(viewController, animated: true)
                
            //profileType = .calf
            case .plans:
                guard let viewModel = dataItems[(indexPath as NSIndexPath).row] as? PlanViewModel else {
                    return
                }
                
                let viewController = PlanProfileViewController(plan: viewModel.plan)
                
                navigationController?.pushViewController(viewController, animated: true)
            case .messages:
                break;
            }
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
extension ProfileViewController: UserProfileDelegate {
    func didClickBack() {
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileViewController: AccountProfileDelegate {
    func didAccountProfileClickBack() {
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileViewController: MemberNavigationDelegate {
    func messageClicked() {
        memberNavigationState = .message
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func profileClicked() {
        memberNavigationState = .profile
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func chargeClicked() {
        memberNavigationState = .charge
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
        membershipNavigationState = .members
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func plansClicked() {
        membershipNavigationState = .plans
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
    func messagesClicked() {
        membershipNavigationState = .messages
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.resignFirstResponder()
        reloadInputViews()
    }
}
extension ProfileViewController: SubscriptionDelegate {
    func didCancelSubscription(_ subscription: Subscription) {
        print("cancel subscription")

        let controller = CancelSubscriptionViewController(subscription: subscription)
        controller.cancelSubscriptionDelegate = self
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    func didChangeSubscription(_ subscription: Subscription) {
        print("change subscription")
        let viewController = ChangePlansViewController(user: user, subscription: subscription)
        viewController.changePlanDelegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func didHoldSubscription(_ subscription: Subscription) {
        print("hold subscription")
    }
}
extension ProfileViewController: PaymentCardDelegate {
    func didUpdatePaymentCard(_ paymentCard: PaymentCard) {
        let viewController = CardIOViewController()
        viewController.cardCaptureDelegate = self

        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension ProfileViewController: CancelSubscriptionDelegate {
    func didClose() {
        dismiss(animated: true, completion: nil)
    }
    func didConfirmCancelSubscription(_ subscription: Subscription) {
        ApiManager.sharedInstance.cancelSubscription(subscription.id, success: {
            self.dismiss(animated: true, completion: nil)
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
        
        present(viewController, animated: true) { 
            viewController.scanCard()
        }
    }
}
extension ProfileViewController: CardCaptureDelegate {
    func didCancelCardCapture() {
        navigationController?.popViewController(animated: true)
    }
    func didCompleteCardCapture(_ stpCard: STPCardParams) {
        dismiss(animated: true, completion: {
            SVProgressHUD.show()
            STPAPIClient.shared().createToken(withCard: stpCard, completion: { [weak self] (token, error) in
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
    func didChargeAmount(_ amount: USD) {
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
extension ProfileViewController: MessageViewDelegate {
    func didSubmitMessage(message: String) {
        switch profileType {
        case .bull:
            break
        case .calf:
            let createMessage = ApiManager.CreateMessage(recipient: user, content: message)
            
            ApiManager.sharedInstance.createMessage(createMessage, success: { [weak self] (message) in
                guard let _self = self else {
                    return
                }
                guard let dataSourceItems = _self.dataSource[1] as? [MessagesViewModel] else {
                    return
                }
                var items = _self.dataSource
                
                let messagesViewModel = dataSourceItems[0]
                messagesViewModel.messages.append(message)
                
                items[1] = [messagesViewModel]
                
                _self.dataSource = items
            }) { (error, errorDictionary) in
                print("failed")
            }
        }
    }
}
extension ProfileViewController: ChangePlanDelegate {
    func didCompleteChangePlan(subscription: Subscription) {
        user.memberships[0].subscription = subscription
        buildDataSet()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
