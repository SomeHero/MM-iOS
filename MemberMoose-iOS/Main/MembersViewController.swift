//
//  MembersViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ALTextInputBar
import Kingfisher


class MembersViewController: UIViewController {
    private let membersCellIdentifier                  = "MemberCellIdentifier"
    private let plansCellIdentifier                  = "PlanCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private var membershipNavigationState: MembershipNavigationState = .Members
    private let textInputBar = ALTextInputBar()
    private var profileType: ProfileType = .bull
    
    var members: [MemberViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var plans: [PlanViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
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
        
        _tableView.registerClass(MemberCell.self, forCellReuseIdentifier: self.membersCellIdentifier)
        _tableView.registerClass(PlanCell.self, forCellReuseIdentifier: self.plansCellIdentifier)
        
        _tableView.addSubview(self.emptyState)
        _tableView.addSubview(self.membersEmptyState)
        _tableView.addSubview(self.plansEmptyState)
        _tableView.addSubview(self.messagesEmptyState)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var membersEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    private lazy var createMemberButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MembersViewController.createMemberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Add a Member", forState: .Normal)
        
        return _button
    }()
    private lazy var sharePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MembersViewController.sharePlanClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Share Plan", forState: .Normal)
        
        return _button
    }()
    private lazy var plansEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    private lazy var createPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MembersViewController.createMemberClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Create Plan", forState: .Normal)
        
        return _button
    }()
    private lazy var importFromStripeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.addTarget(self, action: #selector(MembersViewController.sharePlanClicked(_:)), forControlEvents: .TouchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Import from Stripe", forState: .Normal)
        
        return _button
    }()
    private lazy var messagesEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    private lazy var emptyState: EmptyStateView = {
        let _emptyState = EmptyStateView()
        _emptyState.alpha = 0.0
        _emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        return _emptyState
    }()
    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), forState: .Normal)
        _button.addTarget(self, action: #selector(MembersViewController.menuButtonClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Edit"), forState: .Normal)
        _button.addTarget(self, action: #selector(MembersViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()

    private lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch membershipNavigationState {
            case .Messages:
                return textInputBar
            default:
                return nil
            }
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        
        configureRevealControllerGestures(view)
        configureRevealWidth()
        
        setup()
        
        showMembers()
        
        //emptyState.alpha = 1
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       // membershipNavigation.setSelectedButton(membershipNavigationState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            make.top.equalTo(view.snp_bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    func setup() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        membersEmptyState.setup("804RVA has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.")
        membersEmptyState.addButtons([self.createMemberButton, self.sharePlanButton])
        
        plansEmptyState.setup("804RVA has no plans!", subHeader: "The best way to add plans to your community is to create a plan manually or import existing plans from your Stripe account.")
        plansEmptyState.addButtons([self.createPlanButton, self.importFromStripeButton])
        
        messagesEmptyState.setup("It's a bit lonely in here!", subHeader: "You don’t have a members in your community and sadly can’t message anyone.  Well, the Moose would always love to here from you.  Go ahead and send us a message.")
        emptyState.setup("You have no members.", message: "You have no members :(")
    }
    func showMembers() {
        members.removeAll()
        resetEmptyStates()
        tableView.reloadData()
        
        ApiManager.sharedInstance.getMembers({ (members) in
            if(members!.count > 0) {
                var viewModels: [MemberViewModel] = []
                for member in members! {
                    let viewModel = MemberViewModel(user: member)
                    
                    viewModels.append(viewModel)
                }
                self.members = viewModels
            } else {
                self.membersEmptyState.alpha = 1
            }
        }) { (error, errorDictionary) in
            print("error")
            
            self.membersEmptyState.alpha = 1
        }
        tableView.reloadData()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func showPlans() {
        plans.removeAll()
        resetEmptyStates()
        tableView.reloadData()
        
        ApiManager.sharedInstance.getPlans({ (plans) in
            if(plans!.count > 0) {
                var viewModels: [PlanViewModel] = []
                for plan in plans! {
                    let viewModel = PlanViewModel(plan: plan)
                    
                    viewModels.append(viewModel)
                }
                self.plans = viewModels
            } else {
                self.plansEmptyState.alpha = 1
            }
        }) { (error, errorDictionary) in
            print("error")
            
            self.plansEmptyState.alpha = 1
        }
        tableView.reloadData()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func showMessages() {
        plans.removeAll()
        members.removeAll()
        resetEmptyStates()
        tableView.reloadData()
        
        messagesEmptyState.alpha = 1
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func menuButtonClicked(sender: UIButton) {
        //resignFirstResponder()
        reloadInputViews()
        
        toggleMenu(sender)
    }
    func showProfile(sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        let viewController = ProfileViewController(user: user, profileType: .bull)
        viewController.profileDelegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController);
        navigationController.navigationBarHidden = true
        
        presentViewController(navigationController, animated: true, completion: nil)
        
        profileType = .bull
    }
    private func resetEmptyStates() {
        membersEmptyState.alpha = 0
        plansEmptyState.alpha = 0
        messagesEmptyState.alpha = 0
    }
    func createMemberClicked(button: UIButton) {
        
    }
    func sharePlanClicked(button: UIButton) {
        
    }
}
extension MembersViewController: MembershipNavigationDelegate {
    func membersClicked() {
        membershipNavigationState = .Members
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showMembers()
    }
    func plansClicked() {
        membershipNavigationState = .Plans
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showPlans()
    }
    func messagesClicked() {
        membershipNavigationState = .Messages
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showMessages()
    }
}

extension MembersViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch membershipNavigationState {
        case .Members:
            return members.count
        default:
            return plans.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch membershipNavigationState {
        case .Members:
            let viewModel = members[indexPath.item]
            let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
            
            //cell.setupWith(viewModel)
            cell.layoutIfNeeded()
            
            return cell
        default:
            let viewModel = plans[indexPath.item]
            let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
            
            //cell.setupWith(viewModel)
            cell.layoutIfNeeded()
            
            return cell
        }
    }
}
extension MembersViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch membershipNavigationState {
        case .Members:
            let viewModel = members[indexPath.item]
            
            let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
            viewController.profileDelegate = self
            
            navigationController?.pushViewController(viewController, animated: true)

            profileType = .calf
        default:
            let viewModel = plans[indexPath.item]
            
            let viewController = PlanDetailViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
        }

    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MembershipHeaderView()
        
        switch membershipNavigationState {
        case .Members:
            headerView.setup("Your Members")
            return headerView
        case .Plans:
            headerView.setup("Your Plans")
            return headerView
        default:
            return nil
        }

    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch membershipNavigationState {
        case .Members:
            if members.count > 0 {
                return 40
            } else {
                return 0
            }
        case .Plans:
            if plans.count > 0 {
                return 40
            } else {
                return 0
            }
        default:
            return 0
        }
    }
}
extension MembersViewController: ProfileDelegate {
    func didBackClicked() {
        switch profileType {
        case .calf:
            navigationController?.popViewControllerAnimated(true)
        case .bull:
            dismissViewControllerAnimated(true, completion: nil)
        }

    }
}
enum MembershipNavigationState {
    case Members
    case Plans
    case Messages
}
protocol MembershipNavigationDelegate: class {
    func membersClicked()
    func plansClicked()
    func messagesClicked()
}
class MembershipNavigationView: UIView {
    weak var delegate: MembershipNavigationDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.membersButton, self.plansButton, self.messagesButton])
        stack.axis = .Horizontal
        stack.distribution = .EqualCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    private lazy var membersButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("MEMBERS", forState: .Normal)
        _button.addTarget(self, action: #selector(MembershipNavigationView.membersClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var plansButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("PLANS", forState: .Normal)
        _button.addTarget(self, action: #selector(MembershipNavigationView.plansClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var messagesButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("MESSAGES", forState: .Normal)
        _button.addTarget(self, action: #selector(MembershipNavigationView.messagesClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    override func updateConstraints() {
        stackView.snp_updateConstraints { (make) in
            make.edges.equalTo(self)
        }
        super.updateConstraints()
    }
    func setSelectedButton(state: MembershipNavigationState) {
        clearButtonSelectedState(membersButton)
        clearButtonSelectedState(plansButton)
        clearButtonSelectedState(messagesButton)
        
        switch state {
        case .Members:
            membersButton.backgroundColor = UIColorTheme.Primary
            membersButton.layer.cornerRadius = membersButton.frame.size.height/2
        case .Plans:
            plansButton.backgroundColor = UIColorTheme.Primary
            plansButton.layer.cornerRadius = plansButton.frame.size.height/2
        case .Messages:
            messagesButton.backgroundColor = UIColorTheme.Primary
            messagesButton.layer.cornerRadius = messagesButton.frame.size.height/2
        }
    }
    private func clearButtonSelectedState(button: UIButton) {
        button.backgroundColor = .clearColor()
    }
    func membersClicked(sender: UIButton) {
        delegate?.membersClicked()
    }
    func plansClicked(sender: UIButton) {
        delegate?.plansClicked()
    }
    func messagesClicked(sender: UIButton) {
        delegate?.messagesClicked()
    }
}
class MembershipHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Default)
        
        self.addSubview(_label)
        
        return _label
    }()
    private lazy var addButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.blueColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        _button.addTarget(self, action: #selector(MembershipHeaderView.addButtonClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.addSubview(_button)
        
        return _button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.snp_updateConstraints { (make) in
            make.bottom.leading.equalTo(self).inset(10)
        }
        addButton.snp_updateConstraints { (make) in
            make.leading.equalTo(titleLabel.snp_trailing).offset(10)
            make.bottom.trailing.equalTo(self).inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(title: String) {
        titleLabel.text = title
        addButton.setTitle("Add", forState: .Normal)
    }
    func addButtonClicked(sender: UIButton) {
        
    }
}
class MembershipEmptyState: UIView {
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.addSubview(_view)
        
        return _view
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .ScaleAspectFit
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.snp_updateConstraints { (make) in
            make.center.equalTo(self)
            make.edges.equalTo(self).inset(20)
        }
        logo.snp_updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headerLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(headerLabel.snp_bottom)
            make.leading.trailing.equalTo(containerView).inset(40)
        }
        buttonContainer.snp_updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(20)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(header: String, subHeader: String) {
        logo.image = UIImage(named: "Logo-DeadMoose")
        headerLabel.text = header
        subHeadingLabel.text = subHeader
    }
    func addButtons(buttons: [UIButton]) {
        var previousButton: UIButton?
        
        for button in buttons {
            buttonContainer.addSubview(button)
            
            button.snp_updateConstraints { (make) in
                make.leading.trailing.equalTo(buttonContainer).inset(40)
                make.height.equalTo(50)
            }
            if let previousButton = previousButton {
                button.snp_updateConstraints(closure: { (make) in
                    make.top.equalTo(previousButton.snp_bottom).offset(10)
                })
            } else {
                button.snp_updateConstraints(closure: { (make) in
                    make.top.equalTo(buttonContainer)
                })
            }
            
            previousButton = button
        }
        if let previousButton = previousButton {
            previousButton.snp_updateConstraints { (make) in
                make.bottom.equalTo(buttonContainer)
            }
        }
    }
}
class MessageToolbarView: UIView {
    private lazy var messageTextField: UITextField = {
        let _messageTextField = UITextField()
        _messageTextField.backgroundColor = .clearColor()
        _messageTextField.font = UIFontTheme.Regular(.Small)
        _messageTextField.textColor = UIColorTheme.PrimaryFont
        _messageTextField.placeholder = "Enter Message"
        
        self.addSubview(_messageTextField)
        
        return _messageTextField
    }()
    override func updateConstraints() {
        messageTextField.snp_updateConstraints { (make) in
            make.edges.equalTo(self).inset(10)
        }

        super.updateConstraints()
    }
}
