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
        
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.addSubview(_scrollView)
        
        return _scrollView
    }()
    lazy var container: UIStackView = {
        let _container = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel])
        _container.axis = .vertical
        _container.spacing = 10
        _container.distribution = .equalSpacing
        _container.alignment = .center
        
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
        
        _label.font = UIFontTheme.Regular(.large)
        _label.textColor = UIColor.flatBlack()
        _label.numberOfLines = 0
        _label.textAlignment = .center
        
        return _label
    }()
    
    lazy var messageLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColor.flatBlack()
        _label.numberOfLines = 0
        _label.textAlignment = .center
        
        return _label
    }()
    func setup(_ title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        TextDecorator.applyLineHeight(1.2, toLabel: messageLabel)
    }
    override func updateConstraints() {
        //        image.snp_updateConstraints { make in
        //            make.centerX.equalTo(container)
        //        }
        scrollView.snp.updateConstraints { make in
            make.edges.equalTo(self)
        }
        container.snp.updateConstraints { make in
            make.leading.trailing.equalTo(self).inset(20)
            make.centerY.equalTo(self).offset(-20)
            make.width.equalTo(UIScreen.main.bounds.width-(20*2))
        }
        
        super.updateConstraints()
    }
}
