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
class PlanProfileViewController: UIViewController {
    weak var planProfileDelegate: PlanProfileDelegate?
    
    fileprivate let plan: Plan
    fileprivate let profileCellIdentifier           = "PlanProfileHeaderCellIdentifier"
    fileprivate let newProfileCellIdentifier           = "NewPlanProfileHeaderCellIdentifier"
    fileprivate let planPaymentCellIdentifier       = "PlanPaymentDetailsCellIdentifier"
    fileprivate let planNameCellIdentifier   = "PlanNameCellIdentifier"
    fileprivate let planSignUpFeeCellIdentifier   = "PlanSignUpFeeCellIdentifier"
    fileprivate let planAmountCellIdentifier      = "PlanAmountCellIdentifier"
    fileprivate let planDescriptionCellIdentifier   = "PlanDescriptionCellIdentifier"
    fileprivate let planFeaturesCellIdentifier       = "PlanFeaturesCellIdentifier"
    fileprivate let addPlanFeaturesCellIdentifier       = "AddPlanFeaturesCellIdentifier"
    fileprivate let planTermsOfServiceCellIdentifier = "PlanTermsOfServiceCellIdentifier"
    fileprivate let planSubscriberEmptyStateCellIdentifier    = "PlanSubscriberEmptyStateCellIdentifier"
    fileprivate let planSubscriberCellIdentifier    = "PlanSubscriberCellIdentifier"
    fileprivate let planActivityCellIdentifier      = "PlanActivityCellIdentifier"

    fileprivate let tableCellHeight: CGFloat        = 120
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
    fileprivate lazy var saveButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("SAVE PLAN", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(PlanProfileViewController.savePlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
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
        
        _tableView.register(PlanProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.register(NewPlanProfileHeaderCell.self, forCellReuseIdentifier: self.newProfileCellIdentifier)
        _tableView.register(PlanSignUpFeeCell.self, forCellReuseIdentifier: self.planSignUpFeeCellIdentifier)
        _tableView.register(PlanAmountCell.self, forCellReuseIdentifier: self.planAmountCellIdentifier)
        _tableView.register(PlanPaymentDetailsCell.self, forCellReuseIdentifier: self.planPaymentCellIdentifier)
        _tableView.register(PlanNameCell.self, forCellReuseIdentifier: self.planNameCellIdentifier)
        _tableView.register(PlanDescriptionCell.self, forCellReuseIdentifier: self.planDescriptionCellIdentifier)
        _tableView.register(PlanFeaturesCell.self, forCellReuseIdentifier: self.planFeaturesCellIdentifier)
        _tableView.register(AddPlanFeatureCell.self, forCellReuseIdentifier: self.addPlanFeaturesCellIdentifier)
        _tableView.register(PlanTermsOfServiceCell.self, forCellReuseIdentifier: self.planTermsOfServiceCellIdentifier)
        _tableView.register(PlanSubscriberCell.self, forCellReuseIdentifier: self.planSubscriberCellIdentifier)
        _tableView.register(PlanSubscriberEmptyStateCell.self, forCellReuseIdentifier: self.planSubscriberEmptyStateCellIdentifier)
        _tableView.register(PlanActivityCell.self, forCellReuseIdentifier: self.planActivityCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    init(plan: Plan) {
        self.plan = plan
        
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
        
        title = "Plan"
        view.backgroundColor = .white
        
        configureRevealControllerGestures(view)
        configureRevealWidth()
        
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
        tableView.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
        }
        saveButton.snp.updateConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
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
        
        if let _ = plan.id {
            let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
            items.append([profileHeaderViewModel])
        } else {
            let profileHeaderViewModel = NewPlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
            items.append([profileHeaderViewModel])
        }

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
                }
                else {
                    var viewModels: [PlanSubscriberEmptyStateViewModel] = []
                    viewModels.append(PlanSubscriberEmptyStateViewModel(logo: "Logo-DeadMoose", header: "804RVA has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.", planSubscriberEmptyStateDelegate: _self))
                    
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
        }
        
        dataSource = items
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != tableView {
            return
        }
        
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
        let createPlan = CreatePlan(plan: plan)
        
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
        let updatePlan = UpdatePlan(plan: plan)
        
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
extension PlanProfileViewController : UITableViewDataSource {
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

extension PlanProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        
        switch planNavigationState {
        case .subscribers:
            guard let viewModel = dataItems[(indexPath as NSIndexPath).row] as? MemberViewModel else {
                return
            }
            
            let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
            //viewController.profileDelegate = self
            
            navigationController?.pushViewController(viewController, animated: true)
            
        //profileType = .calf
        case .details:
            let viewModel = dataItems[(indexPath as NSIndexPath).row]
            
            viewModel.didSelectItem?(viewController: self)
        case .activity:
            break;
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
extension PlanProfileViewController: PlanNavigationDelegate {
    func subscribersClicked() {
        planNavigationState = .subscribers
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func activityClicked() {
        planNavigationState = .activity
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func detailsClicked() {
        planNavigationState = .details
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
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
