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
    fileprivate let membersCellIdentifier                  = "MemberCellIdentifier"
    fileprivate let plansCellIdentifier                  = "PlanCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    fileprivate var membershipNavigationState: MembershipNavigationState = .members
    fileprivate let textInputBar = ALTextInputBar()
    fileprivate var profileType: ProfileType = .bull
    
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
        
        _tableView.register(MemberCell.self, forCellReuseIdentifier: self.membersCellIdentifier)
        _tableView.register(PlanCell.self, forCellReuseIdentifier: self.plansCellIdentifier)
        
        _tableView.addSubview(self.emptyState)
        _tableView.addSubview(self.membersEmptyState)
        _tableView.addSubview(self.plansEmptyState)
        _tableView.addSubview(self.messagesEmptyState)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var membersEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    fileprivate lazy var createMemberButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(MembersViewController.createMemberClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Add a Member", for: UIControlState())
        
        return _button
    }()
    fileprivate lazy var sharePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(MembersViewController.sharePlanClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Share Plan", for: UIControlState())
        
        return _button
    }()
    fileprivate lazy var plansEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    fileprivate lazy var createPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(MembersViewController.createMemberClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Create Plan", for: UIControlState())
        
        return _button
    }()
    fileprivate lazy var importFromStripeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.GreenButton
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.addTarget(self, action: #selector(MembersViewController.sharePlanClicked(_:)), for: .touchUpInside)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        _button.setTitle("Import from Stripe", for: UIControlState())
        
        return _button
    }()
    fileprivate lazy var messagesEmptyState: MembershipEmptyState = {
        let _emptyState = MembershipEmptyState()
        _emptyState.alpha = 0.0
        
        return _emptyState
    }()
    fileprivate lazy var emptyState: EmptyStateView = {
        let _emptyState = EmptyStateView()
        _emptyState.alpha = 0.0
        _emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        return _emptyState
    }()
    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Menu"), for: UIControlState())
        _button.addTarget(self, action: #selector(MembersViewController.menuButtonClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Edit"), for: UIControlState())
        _button.addTarget(self, action: #selector(MembersViewController.showProfile(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()

    fileprivate lazy var messageToolbarView: MessageToolbarView = {
        let _view = MessageToolbarView()
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch membershipNavigationState {
            case .messages:
                return textInputBar
            default:
                return nil
            }
        }
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureRevealControllerGestures(view)
        configureRevealWidth()
        
        setup()
        
        showMembers()
        
        //emptyState.alpha = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // membershipNavigation.setSelectedButton(membershipNavigationState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    func setup() {
        guard let user = SessionManager.sharedUser, let account = user.account else {
            return
        }
        membersEmptyState.setup("\(account.companyName) has no members!", subHeader: "The best way to add members to your community is to add members manually or send potential members a link to a plan they can subscribe to.")
        membersEmptyState.addButtons([self.createMemberButton, self.sharePlanButton])
        
        plansEmptyState.setup("\(account.companyName) has no plans!", subHeader: "The best way to add plans to your community is to create a plan manually or import existing plans from your Stripe account.")
        plansEmptyState.addButtons([self.createPlanButton, self.importFromStripeButton])
        
        messagesEmptyState.setup("It's a bit lonely in here!", subHeader: "You don’t have a members in your community and sadly can’t message anyone.  Well, the Moose would always love to here from you.  Go ahead and send us a message.")
        emptyState.setup("You have no members.", message: "You have no members :(")
    }
    func showMembers() {
        members.removeAll()
        resetEmptyStates()
        tableView.reloadData()
        
        ApiManager.sharedInstance.getMembers(1, success: { (members) in
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
        
        ApiManager.sharedInstance.getPlans(1, success: { (plans) in
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
    func menuButtonClicked(_ sender: UIButton) {
        //resignFirstResponder()
        reloadInputViews()
        
        toggleMenu(sender)
    }
    func showProfile(_ sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        let viewController = ProfileViewController(user: user, profileType: .bull)
        viewController.profileDelegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController);
        navigationController.isNavigationBarHidden = true
        
        present(navigationController, animated: true, completion: nil)
        
        profileType = .bull
    }
    fileprivate func resetEmptyStates() {
        membersEmptyState.alpha = 0
        plansEmptyState.alpha = 0
        messagesEmptyState.alpha = 0
    }
    func createMemberClicked(_ button: UIButton) {
        
    }
    func sharePlanClicked(_ button: UIButton) {
        
    }
}
extension MembersViewController: MembershipNavigationDelegate {
    func membersClicked() {
        membershipNavigationState = .members
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showMembers()
    }
    func plansClicked() {
        membershipNavigationState = .plans
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showPlans()
    }
    func messagesClicked() {
        membershipNavigationState = .messages
        //membershipNavigation.setSelectedButton(membershipNavigationState)
        
        showMessages()
    }
}

extension MembersViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch membershipNavigationState {
        case .members:
            return members.count
        default:
            return plans.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch membershipNavigationState {
        case .members:
            let viewModel = members[(indexPath as NSIndexPath).item]
            let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
            
            //cell.setupWith(viewModel)
            cell.layoutIfNeeded()
            
            return cell
        default:
            let viewModel = plans[(indexPath as NSIndexPath).item]
            let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
            
            //cell.setupWith(viewModel)
            cell.layoutIfNeeded()
            
            return cell
        }
    }
}
extension MembersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch membershipNavigationState {
        case .members:
            let viewModel = members[(indexPath as NSIndexPath).item]
            
            let viewController = ProfileViewController(user: viewModel.user, profileType: .calf)
            viewController.profileDelegate = self
            
            navigationController?.pushViewController(viewController, animated: true)

            profileType = .calf
        default:
            let viewModel = plans[(indexPath as NSIndexPath).item]
            
            let viewController = PlanDetailViewController(plan: viewModel.plan)
            
            navigationController?.pushViewController(viewController, animated: true)
        }

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MembershipHeaderView()
        
        switch membershipNavigationState {
        case .members:
            headerView.setup("Your Members")
            return headerView
        case .plans:
            headerView.setup("Your Plans")
            return headerView
        default:
            return nil
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch membershipNavigationState {
        case .members:
            if members.count > 0 {
                return 40
            } else {
                return 0
            }
        case .plans:
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
            navigationController?.popViewController(animated: true)
        case .bull:
            dismiss(animated: true, completion: nil)
        }

    }
}
enum MembershipNavigationState {
    case members
    case plans
    case messages
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
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    fileprivate lazy var membersButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("MEMBERS", for: UIControlState())
        _button.addTarget(self, action: #selector(MembershipNavigationView.membersClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var plansButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("PLANS", for: UIControlState())
        _button.addTarget(self, action: #selector(MembershipNavigationView.plansClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var messagesButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("MESSAGES", for: UIControlState())
        _button.addTarget(self, action: #selector(MembershipNavigationView.messagesClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    override func updateConstraints() {
        stackView.snp.updateConstraints { (make) in
            make.edges.equalTo(self)
        }
        super.updateConstraints()
    }
    func setSelectedButton(_ state: MembershipNavigationState) {
        clearButtonSelectedState(membersButton)
        clearButtonSelectedState(plansButton)
        clearButtonSelectedState(messagesButton)
        
        switch state {
        case .members:
            membersButton.backgroundColor = UIColorTheme.Primary
            membersButton.layer.cornerRadius = 40/2
        case .plans:
            plansButton.backgroundColor = UIColorTheme.Primary
            plansButton.layer.cornerRadius = 40/2
        case .messages:
            messagesButton.backgroundColor = UIColorTheme.Primary
            messagesButton.layer.cornerRadius = 40/2
        }
    }
    fileprivate func clearButtonSelectedState(_ button: UIButton) {
        button.backgroundColor = .clear
    }
    func membersClicked(_ sender: UIButton) {
        delegate?.membersClicked()
    }
    func plansClicked(_ sender: UIButton) {
        delegate?.plansClicked()
    }
    func messagesClicked(_ sender: UIButton) {
        delegate?.messagesClicked()
    }
}
class MembershipHeaderView: UIView {
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.font = UIFontTheme.Regular(.default)
        
        self.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var addButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(.blue, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        _button.addTarget(self, action: #selector(MembershipHeaderView.addButtonClicked(_:)), for: .touchUpInside)
        
        self.addSubview(_button)
        
        return _button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.snp.updateConstraints { (make) in
            make.bottom.leading.equalTo(self).inset(10)
        }
        addButton.snp.updateConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.bottom.trailing.equalTo(self).inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(_ title: String) {
        titleLabel.text = title
        addButton.setTitle("Add", for: UIControlState())
    }
    func addButtonClicked(_ sender: UIButton) {
        
    }
}
class MembershipEmptyState: UIView {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.snp.updateConstraints { (make) in
            make.center.equalTo(self)
            make.edges.equalTo(self).inset(20)
        }
        logo.snp.updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        headerLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.trailing.equalTo(containerView).inset(40)
        }
        buttonContainer.snp.updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(20)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(_ header: String, subHeader: String) {
        logo.image = UIImage(named: "Logo-DeadMoose")
        headerLabel.text = header
        subHeadingLabel.text = subHeader
    }
    func addButtons(_ buttons: [UIButton]) {
        var previousButton: UIButton?
        
        for button in buttons {
            buttonContainer.addSubview(button)
            
            button.snp.updateConstraints { (make) in
                make.leading.trailing.equalTo(buttonContainer).inset(40)
                make.height.equalTo(50)
            }
            if let previousButton = previousButton {
                button.snp.updateConstraints({ (make) in
                    make.top.equalTo(previousButton.snp.bottom).offset(10)
                })
            } else {
                button.snp.updateConstraints({ (make) in
                    make.top.equalTo(buttonContainer)
                })
            }
            
            previousButton = button
        }
        if let previousButton = previousButton {
            previousButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(buttonContainer)
            }
        }
    }
}
class MessageToolbarView: UIView {
    fileprivate lazy var messageTextField: UITextField = {
        let _messageTextField = UITextField()
        _messageTextField.backgroundColor = .clear
        _messageTextField.font = UIFontTheme.Regular(.small)
        _messageTextField.textColor = UIColorTheme.PrimaryFont
        _messageTextField.placeholder = "Enter Message"
        
        self.addSubview(_messageTextField)
        
        return _messageTextField
    }()
    override func updateConstraints() {
        messageTextField.snp.updateConstraints { (make) in
            make.edges.equalTo(self).inset(10)
        }

        super.updateConstraints()
    }
}
