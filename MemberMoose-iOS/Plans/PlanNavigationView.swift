//
//  PlanNavigationView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

enum PlanNavigationState {
    case subscribers
    case activity
    case details
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
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    fileprivate lazy var subscribersButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("ROSTER", for: UIControlState())
        _button.addTarget(self, action: #selector(PlanNavigationView.subscribersClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var activityButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("ACTIVITY", for: UIControlState())
        _button.addTarget(self, action: #selector(PlanNavigationView.activityClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var detailsButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("DETAILS", for: UIControlState())
        _button.addTarget(self, action: #selector(PlanNavigationView.detailsClicked(_:)), for: .touchUpInside)
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
    func setSelectedButton(_ state: PlanNavigationState) {
        clearButtonSelectedState(subscribersButton)
        clearButtonSelectedState(activityButton)
        clearButtonSelectedState(detailsButton)
        
        switch state {
        case .subscribers:
            subscribersButton.backgroundColor = UIColorTheme.Primary
            subscribersButton.layer.cornerRadius = 40/2
        case .activity:
            activityButton.backgroundColor = UIColorTheme.Primary
            activityButton.layer.cornerRadius = 40/2
        case .details:
            detailsButton.backgroundColor = UIColorTheme.Primary
            detailsButton.layer.cornerRadius = 40/2
        }
    }
    fileprivate func clearButtonSelectedState(_ button: UIButton) {
        button.backgroundColor = .clear
    }
    func subscribersClicked(_ sender: UIButton) {
        delegate?.subscribersClicked()
    }
    func activityClicked(_ sender: UIButton) {
        delegate?.activityClicked()
    }
    func detailsClicked(_ sender: UIButton) {
        delegate?.detailsClicked()
    }
}
