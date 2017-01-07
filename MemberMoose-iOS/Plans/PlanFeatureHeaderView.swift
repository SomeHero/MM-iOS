//
//  PlanFeatureHeaderView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PlanFeatureHeaderView: UIView {
    weak var addPlanFeatureDelegate: AddPlanFeatureDelegate?
    weak var presentingViewController: UIViewController?
    
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.font = UIFontTheme.SemiBold()
        
        self.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var addButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 18)
        _button.setTitleColor(UIColorTheme.PrimaryFont, for: .normal)
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: .highlighted)
        _button.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        _button.backgroundColor = UIColor.clear
        
        _button.addTarget(self, action: #selector(PlanFeatureHeaderView.addClicked(_:)), for: .touchUpInside)
        
        self.addSubview(_button)
        
        return _button
    }()
    lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = .flatWhite()
        
        self.addSubview(_lineView)
        
        return _lineView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
        }
        addButton.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).inset(10)
            make.trailing.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(kOnePX*2)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(_ title: String) {
        titleLabel.text = title
    }
    func addClicked(_ sender: UIButton) {
        let textEditorViewController = TextEditorViewController(title: "Plan Feature", text: "")
        textEditorViewController.textEditorDelegate = self
        
        presentingViewController?.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
}
extension PlanFeatureHeaderView: TextEditorDelegate {
    func didSubmitText(text: String) {
        addPlanFeatureDelegate?.didAddPlanFeature(text: text)
    }
}
