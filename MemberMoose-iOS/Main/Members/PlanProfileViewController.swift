//
//  PlanDetailViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD
import Presentr

protocol PlanProfileDelegate: class {
    func didDismissPlanProfile()
}
class PlanProfileViewController: UICollectionViewController {
    weak var planProfileDelegate: PlanProfileDelegate?
    var avatar: UIImage?
    fileprivate let plan: Plan
    
    fileprivate var planNavigationState: PlanNavigationState = .details
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
    fileprivate var stretchyFlowLayout: StretchyHeaderCollectionViewLayout {
        return self.collectionView!.collectionViewLayout as! StretchyHeaderCollectionViewLayout
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
    fileprivate lazy var saveButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("SAVE PLAN", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(PlanProfileViewController.savePlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    var dataSource: [[DataSourceItemProtocol]] = []
    
    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), for: UIControlState())
        _button.addTarget(self, action: #selector(PlanProfileViewController.backClicked(_:)), for: .touchUpInside)
        
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

    fileprivate lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    init(plan: Plan) {
        self.plan = plan
        
        let layout = StretchyHeaderCollectionViewLayout()
        layout.minimumInteritemSpacing = 50.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
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
        
        title = "Plan"
        view.backgroundColor = .white
        
        configureRevealControllerGestures(view)
        configureRevealWidth()
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = .white
        collectionView!.register(PlanProfileCollectionViewCell.self, forCellWithReuseIdentifier: "PlanProfileCollectionViewCell")
        
        collectionView!.register(PlanProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PlanProfileHeaderView")
        
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
//            _self.pageNumber += 1
//            
//            switch _self.planNavigationState {
//            case .subscribers:
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
//                    }, failure: { [weak self] (error, errorDictionary) in
//                        SVProgressHUD.dismiss()
//                        
//                        guard let _self = self else {
//                            return
//                        }
//                        
//                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
//                })
//            case .activity:
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
//                    }, failure: {[weak self] (error, errorDictionary) in
//                        SVProgressHUD.dismiss()
//                        
//                        guard let _self = self else {
//                            return
//                        }
//                        
//                        ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
//                })
//            case .details: break
//            }
//            
//            scrollView.finishInfiniteScroll()
//        }
        
        pageNumber = 1
        buildDataSet()
        
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        saveButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(view)
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(60)
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
//        switch planNavigationState {
//        case .subscribers:
//            var offset = 60
//            var tableViewOffset = 0
//            if hasMembers {
//                offset = 0
//                tableViewOffset = 60
//            }
//            addMemberButton.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(offset)
//            }
//            addPlanButton.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(60)
//            }
//            tableView.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view).inset(tableViewOffset)
//            }
//        case .details:
//            var offset = 60
//            var tableViewOffset = 0
//            if hasPlans {
//                offset = 0
//                tableViewOffset = 60
//            }
//            addMemberButton.snp.updateConstraints({ (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(60)
//            })
//            addPlanButton.snp.updateConstraints({ (make) in
//                make.bottom.equalTo(view.snp.bottom).offset(offset)
//            })
//            tableView.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view).inset(tableViewOffset)
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        if let planName = plan.name {
            navHeaderNameLabel.text = planName
        } else {
            navHeaderNameLabel.text = "New Plan"
        }
    }
    func backClicked(_ sender: UIButton) {
        planProfileDelegate?.didDismissPlanProfile()
    }
    func savePlanClicked(_ button: UIButton) {
        if let _ = plan.id {
            savePlan()
        } else {
            plan.interval = .month

            createPlan()
        }
    }
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        
//        if let _ = plan.id {
//            let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
//            profileHeaderViewModel.presentingViewController = self
//            profileHeaderViewModel.planProfileHeaderViewModelDelegate = self
//            
//            items.append([profileHeaderViewModel])
//        } else {
//            let profileHeaderViewModel = NewPlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
//            profileHeaderViewModel.presentingViewController = self
//            profileHeaderViewModel.planProfileHeaderViewModelDelegate = self
//            
//            items.append([profileHeaderViewModel])
//        }

        switch planNavigationState {
        case .details:
            
            let planNameViewModel = PlanNameViewModel(plan: plan)
            planNameViewModel.planNameDelegate = self
            
            items.append([planNameViewModel])
            
            let planSignUpFeeViewModel = PlanSignUpFeeViewModel(plan: plan)
            planSignUpFeeViewModel.planSignUpFeeDelegate = self
            
            items.append([planSignUpFeeViewModel])
            
            let planAmountView = PlanAmountViewModel(plan: plan)
            planAmountView.planAmountDelegate = self
            
            items.append([planAmountView])

            let planFreeTrialDaysViewModel = FreeTrialPeriodViewModel(plan: plan)
            planFreeTrialDaysViewModel.freeTrialPeriodDelegate = self
            
            items.append([planFreeTrialDaysViewModel])
            
            let planDescriptionViewModel = PlanDescriptionViewModel(plan: plan)
            planDescriptionViewModel.planDescriptionDelegate = self
              
            items.append([planDescriptionViewModel])
            
            let planFeaturesViewModel = PlanFeaturesViewModel(plan: plan)
            planFeaturesViewModel.planFeaturesDelegate = self
            planFeaturesViewModel.addPlanFeaturesDelegate = self
            planFeaturesViewModel.planFeatureDelegate = self
            planFeaturesViewModel.presentingViewController = self
            
            items.append([planFeaturesViewModel])
            
            let planTermOfServiceViewModel = PlanTermsOfServiceViewModel(plan: plan)
            planTermOfServiceViewModel.planTermsOfServiceDelegate = self
            
            items.append([planTermOfServiceViewModel])
        case.activity:
            let activities = ["James Rhodes subscribed!",
                            "James Rhodes payment failed.",
                            "James Rhodes paid $25.00",
                            "James Rhodes unsubscribed :9",
            ]
            var activityViewModels: [PlanActivityViewModel] = []
            for activity in activities {
                activityViewModels.append(PlanActivityViewModel(activity: activity))
            }
            items.append(activityViewModels)
            
        case .subscribers:
            ApiManager.sharedInstance.getMembers(plan, self.pageNumber, success: { [weak self] (members) in
                guard let _self = self else {
                    return
                }
                if(members!.count > 0) {
                    _self.hasMembers = true
                    
                    var viewModels: [PlanSubscriberViewModel] = []
                    for member in members! {
                        let viewModel = PlanSubscriberViewModel(user: member)
                        
                        viewModels.append(viewModel)
                    }
                    items.append(viewModels)
                    
                    _self.dataSource = items
                    _self.collectionView!.reloadData()
                    
                }
                else {
                    var viewModels: [PlanSubscriberEmptyStateViewModel] = []
                    viewModels.append(PlanSubscriberEmptyStateViewModel(logo: "Logo-DeadMoose", header: "804RVA has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.", planSubscriberEmptyStateDelegate: _self))
                    
                    items.append(viewModels)
                    _self.dataSource = items
                    _self.collectionView!.reloadData()
                    
                }
            }) { [weak self] (error, errorDictionary) in
                SVProgressHUD.dismiss()
                
                guard let _self = self else {
                    return
                }
                
                ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
            }
        }
        
        dataSource = items
        collectionView!.reloadData()
        
        updateFlowLayoutIfNeeded()
        
        validateForm()
    }
    func validateForm() {
        guard let planName = plan.name else {
            disableButton(saveButton)
            
            return
        }
        let planNameValid = Validator.isValidText(planName)
        
        guard let recurringAmount = plan.amount else {
            disableButton(saveButton)
            
            return
        }
        let recurringAmountValid = true;// Validator.isValidEmail(emailAddress)
        
        guard let recurringInterval = plan.interval else {
            disableButton(saveButton)
            
            return
        }
        let recurringIntervalValid = true
        
        if planNameValid && recurringAmountValid && recurringIntervalValid {
            enableButton(saveButton)
        } else {
            disableButton(saveButton)
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
            
            let labelTransform = CATransform3DMakeTranslation(0, max(0.0, parallaxHeight - yOffset + labelHeaderAdditionalOffset), 0)
            navHeaderNameLabel.layer.transform = labelTransform
        }
    }
    func addPlanClicked(_ sender: UIButton) {
        let viewController = PlanProfileViewController(plan: plan)
        viewController.planProfileDelegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func addMemberClicked(_ sender: UIButton) {
        let viewController = SharePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func createPlan() {
        let createPlan = CreatePlan(plan: plan, avatar: avatar)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.createPlan(createPlan, success: { [weak self] (plan) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            print("plan saved")
            
            _self.dismiss(animated: true, completion: nil)

        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
    func savePlan() {
        let updatePlan = UpdatePlan(plan: plan, avatar: avatar)
        
        SVProgressHUD.show()
        
        ApiManager.sharedInstance.updatePlan(updatePlan, success: { [weak self] (plan) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            print("plan saved")
            
            let _ = _self.navigationController?.popViewController(animated: true)

        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }
}
extension PlanProfileViewController: PlanNavigationDelegate {
    func subscribersClicked() {
        planNavigationState = .subscribers
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
    }
    func activityClicked() {
        planNavigationState = .activity
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
    }
    func detailsClicked() {
        planNavigationState = .details
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
    }
}
extension PlanProfileViewController: PlanSubscriberEmptyStateDelegate {
    func didCreatePlanSubscriber() {
        
    }
    func didSharePlanToSubscriber(){
        
    }
}
extension PlanProfileViewController: PlanFeaturesCellDelegate {
    func didSelectItem(feature: String) {
        let textEditorViewController = TextEditorViewController(title: "Feature", text: feature)
        //textEditorViewController.textEditorDelegate = self
        
        navigationController?.pushViewController(textEditorViewController, animated: true)
    }
}
extension PlanProfileViewController: PlanAmountDelegate {
    func didUpdatePlanAmount(text: String, interval: RecurringInterval) {
        plan.amount = Double(text)
        plan.interval = interval
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanSignUpFeeDelegate {
    func didUpdateSignUpFee(text: String) {
        plan.oneTimeAmount = Double(text)
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanDescriptionDelegate {
    func didUpdatePlanDescription(text: String) {
        plan.description = text
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanNameDelegate {
    func didUpdatePlanName(text: String) {
        plan.name = text
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: AddPlanFeatureDelegate {
    func didAddPlanFeature(text: String) {
        plan.features.append(text)
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanFeatureDelegate {
    func didUpdatePlanFeature(text: String, index: Int) {
        plan.features[index] = text
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: FreeTrialPeriodDelegate {
    func didUpdateFreeTrialPeriod(days: Int) {
        plan.trialPeriodDays = days
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanTermsOfServiceDelegate {
    func didUpdateTermsOfService(text: String) {
        plan.termsOfService = text
        
        buildDataSet()
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PlanProfileViewController: PlanProfileDelegate {
    func didDismissPlanProfile() {
        dismiss(animated: true, completion: nil)
    }
}
extension PlanProfileViewController: PlanProfileHeaderViewModelDelegate {
    func didUpdatePlanAvatar(avatar: UIImage) {
        self.avatar = avatar
    }
}
extension PlanProfileViewController: NewPlanProfileHeaderViewModelDelegate {
    func didAddPlanAvatar(avatar: UIImage) {
        self.avatar = avatar
    }
}
extension PlanProfileViewController: PlanProfileCollectionViewCellDelegate {
    func didSelectPlanProfileRow(viewModel: DataSourceItemProtocol) {
        viewModel.didSelectItem?(viewController: self)
    }
}
extension PlanProfileViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        //collectionView.registerClass(modelView.cellClass, forCellWithReuseIdentifier: modelView.cellID)
        
        let cell: PlanProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanProfileCollectionViewCell", for: indexPath) as! PlanProfileCollectionViewCell
        cell.dataSource = dataSource
        cell.delegate = self
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
        profileHeaderViewModel.presentingViewController = self
        profileHeaderViewModel.planProfileHeaderViewModelDelegate = self
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlanProfileHeaderView", for: indexPath) as! PlanProfileHeaderView
        header.setupWith(profileHeaderViewModel)
        
        return header
    }
}
extension PlanProfileViewController: UICollectionViewDelegateFlowLayout {
    
    private static var cellHeightCache: [String: CGSize] = [:]
    func updateFlowLayoutIfNeeded(forceReload: Bool = false) {
        guard let collectionView = collectionView else {
            return
        }
        
        let width = collectionView.bounds.width
        
        let headerHeight: CGFloat
        
        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
        
        let header = PlanProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        header.setupWith(profileHeaderViewModel)
        headerHeight = header.systemLayoutHeightForWidth(width: width)
        
        if forceReload || stretchyFlowLayout.headerReferenceSize.height != headerHeight {
            stretchyFlowLayout.headerReferenceSize = CGSize(width: width, height: headerHeight)
            stretchyFlowLayout.invalidateLayout()
            
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let referenceSize = PlanProfileViewController.cellHeightCache["Header"] {
            return referenceSize
        }
        let width = collectionView.bounds.width
        
        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
        
        let header = PlanProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        header.setupWith(profileHeaderViewModel)
        
        let height = header.systemLayoutHeightForWidth(width: width)
        
        let size = CGSize(width: width, height: ceil(height))
        
        PlanProfileViewController.cellHeightCache["Header"] = size
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cell = PlanProfileCollectionViewCell.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
        cell.dataSource = dataSource
        
        let height = cell.getTableViewHeight()
        
        let size = CGSize(width: width, height: ceil(height))
        
        return size
    }
}

