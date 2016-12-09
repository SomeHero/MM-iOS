//
//  DeletePlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/9/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

class DeletePlanViewController: UIViewController, MultilineNavTitlable {
    fileprivate let plan: Plan
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        self.view.addSubview(scroll)
        return scroll
    }()
    lazy var container: UIStackView = {
        let _container = UIStackView(arrangedSubviews: [self.headerLabel, self.descriptionLabel])
        _container.axis = .vertical
        _container.spacing = 10
        _container.distribution = .equalSpacing
        _container.alignment = .center
        
        self.scrollView.addSubview(_container)
        
        return _container
    }()
    lazy var headerLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular(.large)
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.textAlignment = .center
        
        self.scrollView.addSubview(_label)
        
        return _label
    }()
    lazy var descriptionLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular()
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.textAlignment = .center
        
        self.scrollView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var deletePlanButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("DELETE PLAN", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState())
        _button.addTarget(self, action: #selector(DeletePlanViewController.deletePlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    init(plan: Plan) {
        self.plan = plan
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Delete Plan"
        
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(DeletePlanViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        container.snp.updateConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(view).inset(40)
            make.width.equalTo(UIScreen.main.bounds.width-(20*2))
        }
        deletePlanButton.snp.updateConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        })
    }
    func setup() {
        guard let planName = plan.name else {
            return
        }
        configureMultiLineNavTitle(titleNonEmptyString: "Delete Plan", subtitleNonEmptyString: planName)
        
        headerLabel.text = "Are you sure you want to delete the plan \(planName)"
        descriptionLabel.text = "If your continue, all plan subscribers will be un-subscribed from this plan and the plan will no longer be visible.  This action cannot be un-done."
    }
    func validateForm() {
        let isDeletePlanChecked = true

        if isDeletePlanChecked {
            enableButton(deletePlanButton)
        } else {
            disableButton(deletePlanButton)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func deletePlanClicked(_ sender: UIButton) {
        guard let planId = plan.id else {
            return
        }
        
        SVProgressHUD.show()

        ApiManager.sharedInstance.deletePlan(planId, success: { [weak self] () in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            _self.dismiss(animated: true, completion: nil)
            
        }) { [weak self] (error, errorDictionary) in
            SVProgressHUD.dismiss()
            
            guard let _self = self else {
                return
            }
            
            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
        }
    }

}
