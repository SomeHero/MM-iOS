//
//  CreateFirstPlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class CreateFirstPlanViewController: UIViewController {

    private lazy var skipButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.grayColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        skipButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.trailing.equalTo(view).inset(15)
        }
        nextButton.snp_updateConstraints { (make) in
            make.bottom.equalTo(view).inset(60)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
    }
    func setup() {
        skipButton.setTitle("SKIP", forState: .Normal)
    }
    func skipClicked(sender: UIButton) {
        let viewController = ConnectStripeViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func nextClicked(sender: UIButton) {
        let viewController = CreatePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
