//
//  ProfileViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    private let cellIdentifier                  = "SubscriptionCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
   
    var subscriptions: [SubscriptionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsZero
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 10.0
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        self.view.addSubview(collectionView)
        
        return collectionView
    }()
    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), forState: .Normal)
        _button.addTarget(self, action: #selector(ProfileViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
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
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.whiteColor().CGColor
        _imageView.layer.borderWidth = 2.0
        
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
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.flatWhiteColor()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsetsZero
        _tableView.layoutMargins        = UIEdgeInsetsZero
        _tableView.tableFooterView      = UIView()
        _tableView.rowHeight            = self.tableCellHeight
        
        _tableView.registerClass(SubscriptionCell.self, forCellReuseIdentifier: self.cellIdentifier)
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
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        var viewModels: [SubscriptionViewModel] = []
        let viewModel = SubscriptionViewModel(planName: "Membermoose Prime", planAmount: "$30.00/monthly", status: "Active")
        viewModels.append(viewModel)
        subscriptions = viewModels
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
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
            make.bottom.equalTo(topBackgroundView).inset(20)
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
        tableView.snp_updateConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp_bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }
        emptyState.snp_updateConstraints { make in
            make.edges.equalTo(view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
            logo.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
                                    placeholderImage: UIImage(named: "MissingAvatar-Bull"))
        } else {
            logo.image = UIImage(named: "MissingAvatar-Bull")
        }
        companyNameLabel.text = user.companyName
        subHeadingLabel.text = "Member Since Jan 2015"
        
        emptyState.setup("No Subscriptions.", message: "No Subscriptions")
        
    }
    func backClicked(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func showProfile(button: UIButton) {
        
    }

}
extension ProfileViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = subscriptions[indexPath.item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.setupWith(viewModel)
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let viewModel = subscriptions[indexPath.item]
        
        //let viewController = MemberDetailViewController()
        
        //navigationController?.pushViewController(viewController, animated: true)
    }
}
