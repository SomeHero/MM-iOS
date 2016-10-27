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

class PlanProfileViewController: UIViewController {
    private let plan: Plan
    private let profileCellIdentifier           = "PlanProfileHeaderCellIdentifier"
    private let planPaymentCellIdentifier       = "PlanPaymentDetailsCellIdentifier"
    private let planDescriptionCellIdentifier   = "PlanDescriptionCellIdentifier"
    private let planFeatureCellIdentifier       = "PlanFeatureCellIdentifier"
    private let planTermsOfServiceCellIdentifier = "PlanTermsOfServiceCellIdentifier"
    private let planSubscriberCellIdentifier    = "PlanSubscriberCellIdentifier"
    private let planActivityCellIdentifier      = "PlanActivityCellIdentifier"

    private let tableCellHeight: CGFloat        = 120
    private var planNavigationState: PlanNavigationState = .Details
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
        
        _tableView.registerClass(PlanProfileHeaderCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        _tableView.registerClass(PlanPaymentDetailsCell.self, forCellReuseIdentifier: self.planPaymentCellIdentifier)
        _tableView.registerClass(PlanDescriptionCell.self, forCellReuseIdentifier: self.planDescriptionCellIdentifier)
        _tableView.registerClass(PlanFeatureCell.self, forCellReuseIdentifier: self.planFeatureCellIdentifier)
        _tableView.registerClass(PlanTermsOfServiceCell.self, forCellReuseIdentifier: self.planTermsOfServiceCellIdentifier)
        _tableView.registerClass(PlanSubscriberCell.self, forCellReuseIdentifier: self.planSubscriberCellIdentifier)
        _tableView.registerClass(PlanActivityCell.self, forCellReuseIdentifier: self.planActivityCellIdentifier)
        
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
    init(plan: Plan) {
        self.plan = plan
        
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
        
        title = "Plan"
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
            _self.pageNumber += 1
            
            switch _self.planNavigationState {
            case .Subscribers:
                ApiManager.sharedInstance.getMembers(_self.pageNumber, success: { (members) in
                    var viewModels = _self.dataSource[1]
                    for member in members! {
                        let viewModel = MemberViewModel(user: member)
                        
                        viewModels.append(viewModel)
                    }
                    _self.dataSource[1] = viewModels
                    
                    _self.tableView.reloadData()
                    }, failure: { (error, errorDictionary) in
                        print("failed")
                })
            case .Activity:
                ApiManager.sharedInstance.getPlans(_self.pageNumber, success: { (plans) in
                    var viewModels = _self.dataSource[1]
                    for plan in plans! {
                        let viewModel = PlanViewModel(plan: plan)
                        
                        viewModels.append(viewModel)
                    }
                    _self.dataSource[1] = viewModels
                    
                    _self.tableView.reloadData()
                    }, failure: { (error, errorDictionary) in
                        print("failed")
                })
            case .Details: break
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
        switch planNavigationState {
        case .Subscribers:
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
        case .Details:
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        navHeaderNameLabel.text = plan.name
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func editProfileClicked(button: UIButton) {

    }
    func buildDataSet() {
        var items: [[DataSourceItemProtocol]] = []
        
        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
        items.append([profileHeaderViewModel])

        switch planNavigationState {
        case .Details:
            
            let planPaymentDetailsViewModel = PlanPaymentDetailsViewModel(plan: plan)
            items.append([planPaymentDetailsViewModel])
            
            let planDescriptionViewModel = PlanDescriptionViewModel(plan: plan)
            items.append([planDescriptionViewModel])
            
            let features = ["Meeting room for presentations, group meetings, or just additional space to work",
                            "Storage areas are available for $15-$25/month",
                            "Rooftop wifi garden with tables & seating during warm weather",
                            "Excellent coffee from Blanchard's coffee",
                            "Phone booth for step in step out privacy",
                            "Outlets at every seat",
                            "A variety of classes and events for professional development, education, and collaboration",
                            "Unlimited high-speed Wi-Fi internet connection",
                            "Clean, bright, beautiful space designed and built to encourage collaboration",
                            "Clean, bright, beautiful space designed and built to encourage collaboration"
            ]
            var featureViewModels: [PlanFeatureViewModel] = []
            for feature in features {
                featureViewModels.append(PlanFeatureViewModel(feature: feature))
            }
            items.append(featureViewModels)
            
            let planTermOfServiceViewModel = PlanTermsOfServiceViewModel(plan: plan)
            items.append([planTermOfServiceViewModel])
        case.Activity:
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
            
        case .Subscribers:
            ApiManager.sharedInstance.getMembers(self.pageNumber, success: { [weak self] (members) in
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
//                else {
//                    var viewModels: [MemberEmptyStateViewModel] = []
//                    viewModels.append(MemberEmptyStateViewModel(logo: "Logo-DeadMoose", header: "804RVA has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.", memberEmptyStateDelegate: _self))
//                    
//                    items.append(viewModels)
//                    _self.dataSource = items
//                }
            }) { (error, errorDictionary) in
                print("error")
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
        let viewController = PlanProfileViewController(plan: plan)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func addMemberClicked(sender: UIButton) {
        let viewController = SharePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension PlanProfileViewController : UITableViewDataSource {
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

extension PlanProfileViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let dataItems = dataSource[indexPath.section]
        
        switch planNavigationState {
        case .Subscribers:
            guard let viewModel = dataItems[indexPath.row] as? MemberViewModel else {
                return
            }
            
            let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
            //viewController.profileDelegate = self
            
            navigationController?.pushViewController(viewController, animated: true)
            
        //profileType = .calf
        case .Details:
            guard let viewModel = dataItems[indexPath.row] as? PlanViewModel else {
                return
            }
            
//                let viewController = PlanProfileViewController()
//                
//                navigationController?.pushViewController(viewController, animated: true)
        case .Activity:
            break;
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
extension PlanProfileViewController: PlanNavigationDelegate {
    func subscribersClicked() {
        planNavigationState = .Subscribers
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func activityClicked() {
        planNavigationState = .Activity
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func detailsClicked() {
        planNavigationState = .Details
        //planNavigation.setSelectedButton(memberNavigationState)
        
        handleNavHeaderScrollingWithOffset(0)
        pageNumber = 1
        buildDataSet()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
}