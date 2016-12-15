//
//  MemberProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/15/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Presentr
import Stripe
import SVProgressHUD
import Money
import SlackTextViewController
import SideMenu

private let reuseIdentifier = "MemberCell"


protocol MemberProfileDelegate: class {
    func didDismissMemberProfile()
    func didAddMember(user: User)
    func didUpdateMember(user: User)
    func didDeleteMember(user: User)
}
class MemberProfileViewController: UICollectionViewController, MultilineNavTitlable {
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
    weak var memberProfileDelegate: MemberProfileDelegate?
    
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
    fileprivate var dataSource: [[DataSourceItemProtocol]] = []  {
        didSet {
            MemberProfileViewController.cellHeightCache.removeAll(keepingCapacity: true)
        }
    }
    
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
        _button.setImage(UIImage(named:"Back-Reverse"), for: UIControlState())
        _button.addTarget(self, action: #selector(MemberProfileViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), for: UIControlState())
        _button.addTarget(self, action: #selector(MemberProfileViewController.editProfileClicked(_:)), for: .touchUpInside)
        
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
        
        MemberProfileViewController.cellHeightCache.removeAll(keepingCapacity: true)
        
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
        collectionView!.register(NewMemberProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "NewMemberProfileHeaderView")
        
        
        ApiManager.sharedInstance.me({[weak self]  (user) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            SessionManager.sharedUser = user
            SessionManager.persistUser()
            
            _self.pageNumber = 1
            _self.buildDataSet()
            
            PushNotificationManager.registerForPushNotifications()
            }, failure: { [weak self] (error, errorDictionary) in
                guard let _self = self else {
                    return
                }
                
                ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        })
        let memberMenuViewController = MemberMenuViewController(user: user)
        //planMenuViewController.planProfileDelegate = self
        
        let menuRightNavigationController = PlanMenuNavigationViewController(rootViewController: memberMenuViewController)
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = UIScreen.main.bounds.width * 0.4
        
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
            //if let _ = user.id {
            //   make.height.width.equalTo(20)
            //} else {
                make.height.width.equalTo(0)
            //}
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
        
        super.viewDidLayoutSubviews()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        if let firstName = user.firstName, let lastName = user.lastName {
            navHeaderNameLabel.text = "\(firstName) \(lastName)"
        } else {
            navHeaderNameLabel.text = user.emailAddress
        }
    }
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        hasMembers = false
        hasPlans = false
        
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
            let memberNameViewModel = MemberNameViewModel(member: user)
            items.append([memberNameViewModel])
            
            let memberEmailAddressViewModel = MemberEmailAddressViewModel(member: user)
            items.append([memberEmailAddressViewModel])
            
            if user.memberships.count > 0 {
                var subscriptionViewModels: [SubscriptionViewModel] = []
                for membership in user.memberships {
                    for subscription in membership.subscriptions {
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
        
        dataSource = items
        updateFlowLayoutIfNeeded()
        
        collectionView!.reloadData()
    }
    
    func backClicked(_ sender: UIButton) {
        memberProfileDelegate?.didDismissMemberProfile()
    }
    func editProfileClicked(_ button: UIButton) {
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
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
        //viewController.planProfileDelegate = self
        
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

extension MemberProfileViewController {
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
        //cell.profileCollectionViewCellDelegate = self
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let _ = user.id {
            let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalfProfileHeaderView", for: indexPath) as! CalfProfileHeaderView
            header.setupWith(profileHeaderViewModel)
            
            return header
        } else {
            let profileHeaderViewModel = NewMemberProfileHeaderViewModel(user: user)
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewMemberProfileHeaderView", for: indexPath) as! NewMemberProfileHeaderView
            header.setupWith(profileHeaderViewModel)
            
            return header
        }
    }
}
extension MemberProfileViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate static var cellHeightCache: [String: CGSize] = [:]
    func updateFlowLayoutIfNeeded(forceReload: Bool = false) {
        guard let collectionView = collectionView else {
            return
        }
        
        let width = collectionView.bounds.width
        
        let headerHeight: CGFloat
        
        let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
        
        let header = CalfProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        header.setupWith(profileHeaderViewModel)
        
        let height = header.systemLayoutHeightForWidth(width: width)
        
        headerHeight = height
        
        if forceReload || stretchyFlowLayout.headerReferenceSize.height != headerHeight {
            stretchyFlowLayout.headerReferenceSize = CGSize(width: width, height: headerHeight)
            stretchyFlowLayout.invalidateLayout()
            
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let referenceSize = MemberProfileViewController.cellHeightCache["Header"] {
            return referenceSize
        }
        let width = collectionView.bounds.width
        
        if let _ = user.id {
            let profileHeaderViewModel = CalfProfileHeaderViewModel(user: user, memberNavigationState: memberNavigationState, memberNavigationDelegate: self)
            
            let header = CalfProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            let size = CGSize(width: width, height: ceil(height))
            
            MemberProfileViewController.cellHeightCache["Header"] = size
            
            return size
        } else {
            let profileHeaderViewModel = NewMemberProfileHeaderViewModel(user: user)
            
            let header = NewMemberProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
            header.setupWith(profileHeaderViewModel)
            
            let height = header.systemLayoutHeightForWidth(width: width)
            
            let size = CGSize(width: width, height: ceil(height))
            
            MemberProfileViewController.cellHeightCache["Header"] = size
            
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
extension MemberProfileViewController: MemberNavigationDelegate {
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
extension MemberProfileViewController: ChargeCellDelegate {
    func didChargeAmount(_ amount: USD) {
        SVProgressHUD.show()
        
        let createCharge = CreateCharge(user: user, amount: amount.floatValue, description: "Test Charge")
        
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
extension MemberProfileViewController: MessageViewDelegate {
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
extension MemberProfileViewController: SubscriptionDelegate {
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
extension MemberProfileViewController: ChangePlanDelegate {
    func didCompleteChangePlan(subscription: Subscription) {
        //user.memberships[0].subscription = subscription
        //buildDataSet()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
extension MemberProfileViewController: PaymentCardDelegate {
    func didUpdatePaymentCard(_ paymentCard: PaymentCard) {
        let viewController = CardIOViewController()
        viewController.cardCaptureDelegate = self
        
        present(viewController, animated: true) {
            viewController.scanCard()
        }
    }
}
extension MemberProfileViewController: CardCaptureDelegate {
    func didCancelCardCapture() {
        dismiss(animated: true, completion: nil)
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
                    let addPaymentCard = AddPaymentCard(user: _self.user, stripeToken: token.tokenId)
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
extension MemberProfileViewController: CancelSubscriptionDelegate {
    func didClose() {
        dismiss(animated: true, completion: nil)
    }
    func didConfirmCancelSubscription(_ subscription: Subscription) {
        guard let userId = user.id else {
            return
        }
        ApiManager.sharedInstance.cancelSubscription(userId, subscription.id, success: {
            self.dismiss(animated: true, completion: nil)
        }) { (error, errorDictionary) in
            print("error occurred")
        }
    }
}
extension MemberProfileViewController: SubscriptionEmptyStateDelegate {
    func didSubscribe() {
        print("did subscribe")
    }
}
extension MemberProfileViewController: PaymentCardEmptyStateDelegate {
    func didAddPaymentCard() {
        let viewController = CardIOViewController()
        viewController.cardCaptureDelegate = self
        
        present(viewController, animated: true) {
            viewController.scanCard()
        }
    }
}
