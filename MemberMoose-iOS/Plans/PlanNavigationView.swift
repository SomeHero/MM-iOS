//
//  PlanNavigationView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

enum PlanNavigationState {
    case Subscribers
    case Activity
    case Details
}
protocol PlanNavigationDelegate: class {
    func subscribersClicked()
    func activityClicked()
    func detailsClicked()
}
class PlanNavigationView: UIView {
    weak var delegate: PlanNavigationDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.subscribersButton, self.detailsButton, self.activityButton])
        stack.axis = .Horizontal
        stack.distribution = .EqualCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    private lazy var subscribersButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("SUBSCRIBERS", forState: .Normal)
        _button.addTarget(self, action: #selector(PlanNavigationView.subscribersClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var activityButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("ACTIVITY", forState: .Normal)
        _button.addTarget(self, action: #selector(PlanNavigationView.activityClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var detailsButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("DETAILS", forState: .Normal)
        _button.addTarget(self, action: #selector(PlanNavigationView.detailsClicked(_:)), forControlEvents: .TouchUpInside)
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
    func setSelectedButton(state: PlanNavigationState) {
        clearButtonSelectedState(subscribersButton)
        clearButtonSelectedState(activityButton)
        clearButtonSelectedState(detailsButton)
        
        switch state {
        case .Subscribers:
            subscribersButton.backgroundColor = UIColorTheme.Primary
            subscribersButton.layer.cornerRadius = 40/2
        case .Activity:
            activityButton.backgroundColor = UIColorTheme.Primary
            activityButton.layer.cornerRadius = 40/2
        case .Details:
            detailsButton.backgroundColor = UIColorTheme.Primary
            detailsButton.layer.cornerRadius = 40/2
        }
    }
    private func clearButtonSelectedState(button: UIButton) {
        button.backgroundColor = .clearColor()
    }
    func subscribersClicked(sender: UIButton) {
        delegate?.subscribersClicked()
    }
    func activityClicked(sender: UIButton) {
        delegate?.activityClicked()
    }
    func detailsClicked(sender: UIButton) {
        delegate?.detailsClicked()
    }
}