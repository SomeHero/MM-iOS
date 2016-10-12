//
//  EmptyStateView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.addSubview(_scrollView)
        
        return _scrollView
    }()
    lazy var container: UIStackView = {
        let _container = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel])
        _container.axis = .Vertical
        _container.spacing = 10
        _container.distribution = .EqualSpacing
        _container.alignment = .Center
        
        self.scrollView.addSubview(_container)
        
        return _container
    }()
    
    //    lazy var image: UIImageView = {
    //        let _image = UIImageView(image: Image.EmptyInbox)
    //
    //        return _image
    //    }()
    //
    lazy var titleLabel: UILabel = {
        let _label = UILabel()
        
        _label.font = UIFontTheme.Regular(.Large)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        _label.textAlignment = .Center
        
        return _label
    }()
    
    lazy var messageLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        _label.textAlignment = .Center
        
        return _label
    }()
    func setup(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        TextDecorator.applyLineHeight(1.2, toLabel: messageLabel)
    }
    override func updateConstraints() {
        //        image.snp_updateConstraints { make in
        //            make.centerX.equalTo(container)
        //        }
        scrollView.snp_updateConstraints { make in
            make.edges.equalTo(self)
        }
        container.snp_updateConstraints { make in
            make.leading.trailing.equalTo(self).inset(20)
            make.centerY.equalTo(self).offset(-20)
            make.width.equalTo(UIScreen.mainScreen().bounds.width-(20*2))
        }
        
        super.updateConstraints()
    }
}
