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
    var cellID: String { get set }
    var cellClass: UITableViewCell.Type { get set }

    func viewForHeader() -> UIView?
    func heightForHeader() -> CGFloat
    func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    @objc optional func didSelectItem(viewController: UIViewController) 
}
@objc protocol DataSourceItemCell {
    func setupWith(_ viewModel: DataSourceItemProtocol)
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
enum PlanProfileDisplayType {
    case modally
    case nonmodally
}
class ProfileViewController: UICollectionViewController, MultilineNavTitlable {
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
    fileprivate var planProfileDisplayType: PlanProfileDisplayType?
    
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
    fileprivate var dataSource: [[DataSourceItemProtocol]] = []
    
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
//        if tableView.visibleCells.count > 0 {
//            return tableView.visibleCells[0].frame.size.height
//        }
        
        return 130
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
    fileprivate var stretchyFlowLayout: StretchyHeaderCollectionViewLayout {
        return self.collectionView!.collectionViewLayout as! StretchyHeaderCollectionViewLayout
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    init(user: User, profileType: ProfileType) {
        self.user = user
        self.profileType = profileType
        
        let layout = StretchyHeaderCollectionViewLayout()
        layout.minimumInteritemSpacing = 50.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        super.init(collectionViewLayout: layout)
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
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = .white
        collectionView!.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
        collectionView!.register(BullProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BullProfileHeaderView")
        collectionView!.register(CalfProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalfProfileHeaderView")
     
//        self.tableView.infiniteScrollIndicatorStyle = .gray
//        
//        // Set custom indicator margin
//        self.tableView.infiniteScrollIndicatorMargin = 40
//        
//        // Add infinite scroll handler
//        self.tableView.addInfiniteScroll { [weak self] (scrollView) -> Void in
//            guard let _self = self else {
//                return
//            }
//            if _self.profileType == .calf {
//                scrollView.finishInfiniteScroll()
//                
//                return
//            }
//            _self.pageNumber += 1
//            
//            switch _self.membershipNavigationState {
//            case .members:
//                ApiManager.sharedInstance.getMembers(_self.pageNumber, success: { (members) in
//                    var viewModels = _self.dataSource[1]
//                    for member in members! {
//                        let viewModel = MemberViewModel(user: member)
//                        
//                        viewModels.append(viewModel)
//                    }
//                    _self.dataSource[1] = viewModels
//                    
//                    _self.tableView.reloadData()
//                    }, failure: {[weak self] (error, errorDictionary) in
//                        SVProgressHUD.dismiss()
//                        
//                        guard let _self = self else {
//                            return
//                        }
//                        
//                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
//                })
//            case .plans:
//                ApiManager.sharedInstance.getPlans(_self.pageNumber, success: { (plans) in
//                    var viewModels = _self.dataSource[1]
//                    for plan in plans {
//                        let viewModel = PlanViewModel(plan: plan)
//                        
//                        viewModels.append(viewModel)
//                    }
//                    _self.dataSource[1] = viewModels
//                    
//                    _self.tableView.reloadData()
//                    }, failure: { [weak self] (error, errorDictionary) in
//                        SVProgressHUD.dismiss()
//                        
//                        guard let _self = self else {
//                            return
//                        }
//                        
//                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
//                })
//            case .messages: break
//            }
//            
//            scrollView.finishInfiniteScroll()
//        }
        
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
//        tableView.snp.updateConstraints { (make) in
//            make.edges.equalTo(view)
//        }
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
//        switch profileType {
//        case .bull:
//            switch membershipNavigationState {
//            case .members:
//                var offset = 60
//                var tableViewOffset = 0
//                if hasMembers {
//                    offset = 0
//                    tableViewOffset = 60
//                }
//                addMemberButton.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(offset)
//                }
//                addPlanButton.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(60)
//                }
//                tableView.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view).inset(tableViewOffset)
//                }
//            case .plans:
//                var offset = 60
//                var tableViewOffset = 0
//                if hasPlans {
//                    offset = 0
//                    tableViewOffset = 60
//                }
//                addMemberButton.snp.updateConstraints({ (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(60)
//                })
//                addPlanButton.snp.updateConstraints({ (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(offset)
//                })
//                tableView.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view).inset(tableViewOffset)
//                }
//            default:
//                addMemberButton.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(60)
//                }
//                addPlanButton.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view.snp.bottom).offset(60)
//                }
//                tableView.snp.updateConstraints { (make) in
//                    make.bottom.equalTo(view).inset(0)
//                }
//            }
//        default:
//            addMemberButton.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(60)
//            }
//            addPlanButton.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(60)
//            }
//            tableView.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view).inset(0)
//            }
//        }
        
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
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        hasMembers = false
        hasPlans = false

        switch profileType {
        case .bull:
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
                        _self.collectionView!.reloadData()
                        
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
                        _self.collectionView!.reloadData()
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
                let remainingHeight = view.frame.size.height //- tableView.visibleCells[0].frame.size.height

                var viewModels: [MessagesViewModel] = []
                viewModels.append(MessagesViewModel(totalCellHeight: remainingHeight, messages: [], messageViewDelegate: self))

                items.append(viewModels)
                collectionView!.reloadData()
                
                break
            }
        case .calf:
            switch memberNavigationState {
            case .message:
                let remainingHeight = self.view.frame.size.height //- tableView.visibleCells[0].frame.size.height

                ApiManager.sharedInstance.getMessages(user, self.pageNumber, success: { [weak self] (messages) in
                    guard let _self = self, let messages = messages else {
                        return
                    }
                    var viewModels: [MessagesViewModel] = []
                    viewModels.append(MessagesViewModel(totalCellHeight: remainingHeight, messages: messages, messageViewDelegate: self))
                    items.append(viewModels)

                    _self.dataSource = items
                    _self.collectionView!.reloadData()
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
                let remainingHeight = view.frame.size.height //- tableView.visibleCells[0].frame.size.height
                
                let viewModel = ChargeViewModel(totalCellHeight: remainingHeight, chargeCellDelegate: self)
                
                items.append([viewModel])  
            }
        }
        
        dataSource = items
        updateFlowLayoutIfNeeded()
        
        collectionView!.reloadData()
    }

    func backClicked(_ sender: UIButton) {
        switch profileType {
        case .bull:
            toggleMenu(sender)
        case .calf:
            let _ = navigationController?.popViewController(animated: true)
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
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        handleNavHeaderScrollingWithOffset(yOffset)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    func handleNavHeaderScrollingWithOffset(_ yOffset: CGFloat) {
        if chromeVisible {
            navHeaderDarkCoverView.alpha = min(1.0, (yOffset * scrollDarkNavDelayFactor - parallaxHeight + offsetLabelHeaderHeight) *  0.01)
        }
    }
    func addPlanClicked(_ sender: UIButton) {
        let plan = Plan()
        let viewController = PlanProfileViewController(plan: plan)
        viewController.planProfileDelegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = false
        
        planProfileDisplayType = .modally
        present(navigationController, animated: true, completion: nil)
    }
    func addMemberClicked(_ sender: UIButton) {
        //let viewController = SharePlanViewController()
        
        //navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProfileViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row

        //collectionView.registerClass(modelView.cellClass, forCellWithReuseIdentifier: modelView.cellID)
        
        let cell: ProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.dataSource = dataSource
        cell.profileCollectionViewCellDelegate = self
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch profileType {
        case .bull:
            let profileHeaderViewModel = ProfileHeaderViewModel(user: user, membershipNavigationState: membershipNavigationState, membershipNavigationDelegate: self)
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BullProfileHeaderView", for: indexPath) as! BullProfileHeaderView
            header.setupWith(profileHeaderViewModel)
            
            return header
        case .calf:
            let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalfProfileHeaderView", for: indexPath) as! CalfProfileHeaderView
            header.setupWith(profileHeaderViewModel)
            
            return header
        }

    }
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    private static var cellHeightCache: [String: CGSize] = [:]
    func updateFlowLayoutIfNeeded(forceReload: Bool = false) {
        guard let collectionView = collectionView else {
            return
        }
        
        let width = collectionView.bounds.width
        
        let headerHeight: CGFloat
        
        switch profileType {
        case .bull:
            let profileHeaderViewModel = ProfileHeaderViewModel(user: user, membershipNavigationState: membershipNavigationState, membershipNavigationDelegate: self)
            
            let header = BullProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            headerHeight = height
        case .calf:
            let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            let header = CalfProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            headerHeight = height
        }
        
        if forceReload || stretchyFlowLayout.headerReferenceSize.height != headerHeight {
            stretchyFlowLayout.headerReferenceSize = CGSize(width: width, height: headerHeight)
            stretchyFlowLayout.invalidateLayout()
            
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let referenceSize = ProfileViewController.cellHeightCache["Header"] {
            return referenceSize
        }
        let width = collectionView.bounds.width
        
        switch profileType {
        case .bull:
            let profileHeaderViewModel = ProfileHeaderViewModel(user: user, membershipNavigationState: membershipNavigationState, membershipNavigationDelegate: self)
            
            let header = BullProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            let size = CGSize(width: width, height: ceil(height))
            
            ProfileViewController.cellHeightCache["Header"] = size

            return size
        case .calf:
            let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            let header = CalfProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            let size = CGSize(width: width, height: ceil(height))
            
            ProfileViewController.cellHeightCache["Header"] = size
            
            return size
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cell = ProfileCollectionViewCell.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        cell.dataSource = dataSource
        
        let height = cell.getTableViewHeight() + 60
        
        let size = CGSize(width: width, height: ceil(height))
        
        return size
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
    }
    func profileClicked() {
        memberNavigationState = .profile
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
    }
    func chargeClicked() {
        memberNavigationState = .charge
        //memberNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
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
        ApiManager.sharedInstance.cancelSubscription(user.id, subscription.id, success: {
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
        //let viewController = SharePlanViewController()
        
        //navigationController?.pushViewController(viewController, animated: true)
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
                        
                        //_self.buildDataSet()
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
            
            //_self.buildDataSet()
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
//        switch profileType {
//        case .bull:
//            break
//        case .calf:
//            let createMessage = ApiManager.CreateMessage(recipient: user, content: message)
//            
//            ApiManager.sharedInstance.createMessage(createMessage, success: { [weak self] (message) in
//                guard let _self = self else {
//                    return
//                }
//                guard let dataSourceItems = _self.dataSource[1] as? [MessagesViewModel] else {
//                    return
//                }
//                var items = _self.dataSource
//                
//                let messagesViewModel = dataSourceItems[0]
//                messagesViewModel.messages.append(message)
//                
//                items[1] = [messagesViewModel]
//                
//                _self.dataSource = items
//            }) { (error, errorDictionary) in
//                print("failed")
//            }
//        }
    }
}
extension ProfileViewController: ChangePlanDelegate {
    func didCompleteChangePlan(subscription: Subscription) {
        user.memberships[0].subscription = subscription
        //buildDataSet()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
extension ProfileViewController: PlanProfileDelegate {
    func didDismissPlanProfile() {
        guard let planProfileDisplayType = planProfileDisplayType else {
            return
        }
        
        switch planProfileDisplayType {
        case .modally:
            dismiss(animated: true, completion: nil)
        case .nonmodally:
            let _ = navigationController?.popViewController(animated: true)
        }
   }
}
extension ProfileViewController: ProfileCollectionViewCellDelegate {
    func didSelectMember(member: User) {
        let viewController = ProfileViewController(user: member, profileType: .calf)
        viewController.profileDelegate = profileDelegate
        
        planProfileDisplayType = .modally
        navigationController?.pushViewController(viewController, animated: true)
    }
    func didSelectPlan(plan: Plan) {
        let viewController = PlanProfileViewController(plan: plan)
        viewController.planProfileDelegate = self
        
        planProfileDisplayType = .nonmodally
        navigationController?.pushViewController(viewController, animated: true)
    }
}
