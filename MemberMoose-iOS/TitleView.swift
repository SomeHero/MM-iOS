//
//  TitleView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/9/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

private let kDefaultSpacing: CGFloat = -3.0
private let subtitleHeight: CGFloat = 15

protocol MultilineNavTitlable {
    func configureMultiLineNavTitle(titleNonEmptyString title: String, subtitleNonEmptyString subtitle: String)
    func configureMultiLineNavTitle(title: String, attributedSubtitle subtitle: NSAttributedString)
}

extension MultilineNavTitlable where Self : UIViewController {
    // empty string is disallowed for subtitle and title
    func configureMultiLineNavTitle(titleNonEmptyString title: String, subtitleNonEmptyString subtitle: String = "") {
        let titleView = WWTitleView(titleNonEmptyString: title, subtitleNonEmptyString: subtitle)
        configureTitleView(titleView: titleView)
    }
    
    func configureMultiLineNavTitle(title: String, attributedSubtitle subtitle: NSAttributedString) {
        let titleView = WWTitleView(title: title, attributedSubtitle: subtitle)
        configureTitleView(titleView: titleView)
    }
    
    private func configureTitleView(titleView: WWTitleView) {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        }
        navigationItem.titleView = titleView
    }
}

final class WWTitleView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var subtitleHeightConstraint: NSLayoutConstraint!
    private var subtitleSpacing: NSLayoutConstraint!
    
    init(titleNonEmptyString:String, subtitleNonEmptyString: String = "") {
        super.init(frame: CGRect.zero)
        
        assert(titleNonEmptyString != "")
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        configureTitleLabel(title: titleNonEmptyString)
        setSubtitleLabelText(subtitle: subtitleNonEmptyString)
        setupSubtitleConstraints()
        
        configureSize()
    }
    
    init(title: String, attributedSubtitle: NSAttributedString) {
        super.init(frame: CGRect.zero)
        assert(title != "")
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        configureTitleLabel(title: title)
        setSubtitleLabelAttributedText(subtitle: attributedSubtitle)
        setupSubtitleConstraints()
        
        configureSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSize() {
        // after autolayout constraints are made we get the sizing for this view
        let size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        frame = CGRect(x: 0, y:0, width: size.width, height: 35)
    }
    
    func configureTitleLabel(title:String) {
        titleLabel.text = title
        titleLabel.font = UIFontTheme.Bold()
        titleLabel.textColor = UIColorTheme.NavBarForegroundColor
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let lConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let tConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let centerConstraint = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        addConstraints([centerConstraint, topConstraint, tConstraint, lConstraint])
    }
    
    private func setSubtitleLabelText(subtitle: String) {
        subtitleLabel.text = subtitle
        
        subtitleLabel.font = UIFontTheme.Regular(.tiny)
        subtitleLabel.textColor = UIColorTheme.NavBarForegroundColor
    }
    
    private func setSubtitleLabelAttributedText(subtitle: NSAttributedString) {
        subtitleLabel.attributedText = subtitle
    }
    
    func setupSubtitleConstraints() {
        subtitleLabel.sizeToFit()
        subtitleLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        
        subtitleLabel.textAlignment = NSTextAlignment.center
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleSpacing = NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
        let centerConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let tConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let lConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        if subtitleLabel.text == "" {
            subtitleSpacing.constant = 0
        } else {
            subtitleSpacing.constant = kDefaultSpacing
        }
        
        addConstraints([subtitleSpacing, centerConstraint, bottomConstraint, tConstraint, lConstraint])
    }
    
    func setSubtitleText(text: String) {
        subtitleLabel.text = text
        subtitleSpacing.constant = kDefaultSpacing
    }
    
    func subtitleText() -> String? {
        return subtitleLabel.text
    }
    
    func setTitleText(text: String) {
        titleLabel.text = text
    }
}
