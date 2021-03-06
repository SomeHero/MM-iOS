//
//  PlanProfileHeaderView.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/8/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PlanProfileHeaderView: UICollectionReusableView {
    var avatar: UIImage?
    weak var presentingViewController: UIViewController?
    weak var planProfileHeaderViewModelDelegate: PlanProfileHeaderViewModelDelegate?
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var avatarView: EditProfilePhotoView = {
        let _photoView = EditProfilePhotoView()
        //_photoView.buttonTitle = "Upload Avatar"
        _photoView.editPhotoButton.addTarget(self, action: #selector(PlanProfileHeaderCell.editPhotoClicked), for: .touchUpInside)
        
        self.addSubview(_photoView)
        return _photoView
    }()
    fileprivate lazy var headingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .white
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planNavigation: PlanNavigationView = {
        let _view = PlanNavigationView()
        //_view.delegate = self
        self.containerView.addSubview(_view)
        
        return _view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColorTheme.TopBackgroundColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(self).inset(20)
        }
        avatarView.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.centerX.equalTo(containerView)
        }
        headingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(headingLabel.snp.bottom)
            make.centerX.equalTo(containerView)
        }
        planNavigation.snp.updateConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanProfileHeaderViewModel {
            if let avatarImageUrl = viewModel.avatarImageUrl {
                avatarView.profilePhoto.kf.setImage(with: URL(string: avatarImageUrl)!,
                                                    placeholder: UIImage(named: viewModel.avatar))
            } else {
                avatarView.profilePhoto.image = UIImage(named: viewModel.avatar)
            }
            headingLabel.text = viewModel.planName
            subHeadingLabel.text = viewModel.membersCount
            planNavigation.delegate = viewModel.planNavigationDelegate
            planNavigation.setSelectedButton(viewModel.planNavigationState)
            planNavigation.bringSubview(toFront: containerView)
            presentingViewController = viewModel.presentingViewController
            planProfileHeaderViewModelDelegate = viewModel.planProfileHeaderViewModelDelegate
            
            self.bringSubview(toFront: avatarView)
            
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    func editPhotoClicked() {
        guard let presentingViewController = presentingViewController else {
            return
        }
        ImagePicker.presentOn(presentingViewController) { [weak self] image in
            if let image = image {
                let orientedImage = UIImage.getRotatedImageFromImage(image)
                
                self?.addImage(orientedImage)
            }
        }
    }
    func addImage(_ image: UIImage) {
        avatarView.profilePhoto.image = image
        
        planProfileHeaderViewModelDelegate?.didUpdatePlanAvatar(avatar: image)
    }
}
