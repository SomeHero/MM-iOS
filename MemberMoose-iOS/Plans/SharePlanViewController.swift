//
//  SharePlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SharePlanViewController: UIViewController {
//    private lazy var planNameLTextField: UITextField = {
//        
//    }()
//    private lazy var emailAddressTextField: UITextField = {
//        
//    }()
//    private lazy var phoneTextField: UITextField = {
//        
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Share Plan"
        
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

}
