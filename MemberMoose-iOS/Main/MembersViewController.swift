//
//  MembersViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ALTextInputBar

let textInputBar = ALTextInputBar()

class MembersViewController: UIViewController {
    private let membersCellIdentifier                  = "MemberCellIdentifier"
    private let plansCellIdentifier                  = "PlanCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private var membershipNavigationState: MembershipNavigationState = .Members
    
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
        let _tableView                  = UITableView()
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
        
        self.view.addSubview(_tableView)
        return _tableView
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
        _button.addTarget(self, action: #selector(MembersViewController.toggleMenu(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), forState: .Normal)
        _button.addTarget(self, action: #selector(MembersViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
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
    private lazy var membershipNavigation: MembershipNavigationView = {
       let _view = MembershipNavigationView()
        _view.delegate = self
        self.topBackgroundView.addSubview(_view)
        
        return _view
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
        setup()
        
        showMembers()
        
        //emptyState.alpha = 1
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        membershipNavigation.setSelectedButton(membershipNavigationState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        membershipNavigation.snp_updateConstraints { (make) in
            make.top.equalTo(containerView.snp_bottom).offset(20)
            make.leading.trailing.equalTo(topBackgroundView).inset(20)
            make.bottom.equalTo(topBackgroundView).inset(20)
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
    func setup() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        logo.image = UIImage(named: "RVA-Logo")
        companyNameLabel.text = user.companyName
        subHeadingLabel.text = "54 Members"
        emptyState.setup("You have no members.", message: "You have no members :(")
    }
    func showMembers() {
        members.removeAll()
        tableView.reloadData()
        
        ApiManager.sharedInstance.getMembers({ (response) in
            
            var viewModels: [MemberViewModel] = []
            for member in response! {
                let viewModel = MemberViewModel(member: member)
                
                viewModels.append(viewModel)
            }
            self.members = viewModels
        }) { (error, errorDictionary) in
            print("error")
        }
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func showPlans() {
        plans.removeAll()
        tableView.reloadData()
        
        ApiManager.sharedInstance.getPlans({ (response) in
            
            var viewModels: [PlanViewModel] = []
            for plan in response! {
                let viewModel = PlanViewModel(plan: plan)
                
                viewModels.append(viewModel)
            }
            self.plans = viewModels
        }) { (error, errorDictionary) in
            print("error")
        }
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func showMessages() {
        plans.removeAll()
        members.removeAll()
        tableView.reloadData()
        
        view.becomeFirstResponder()
        reloadInputViews()
    }
    func showProfile(sender: UIButton) {
        let viewController = ProfileViewController()

        presentViewController(viewController, animated: true, completion: nil)
    }
}
extension MembersViewController: MembershipNavigationDelegate {
    func membersClicked() {
        membershipNavigationState = .Members
        membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showMembers()
    }
    func plansClicked() {
        membershipNavigationState = .Plans
        membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showPlans()
    }
    func messagesClicked() {
        membershipNavigationState = .Messages
        membershipNavigation.setSelectedButton(membershipNavigationState)
        
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
            
            cell.setupWith(viewModel)
            cell.layoutIfNeeded()
            
            return cell
        default:
            let viewModel = plans[indexPath.item]
            let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
            
            cell.setupWith(viewModel)
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
            
            let viewController = MemberDetailViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
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
            return 80
        case .Plans:
            return 80
        default:
            return 0
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
    override func updateConstraints() {
        titleLabel.snp_updateConstraints { (make) in
            make.top.bottom.leading.equalTo(self).inset(10)
        }
        addButton.snp_updateConstraints { (make) in
            make.leading.equalTo(titleLabel.snp_trailing).offset(10)
            make.top.bottom.trailing.equalTo(self).inset(10)
        }
        super.updateConstraints()
    }
    func setup(title: String) {
        titleLabel.text = title
        addButton.setTitle("Add", forState: .Normal)
    }
    func addButtonClicked(sender: UIButton) {
        
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
