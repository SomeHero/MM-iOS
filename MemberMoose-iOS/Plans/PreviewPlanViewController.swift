//
//  PreviewPlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/9/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PreviewPlanViewController: UICollectionViewController {
    fileprivate let plan: Plan
    
    init(plan: Plan) {
        self.plan = plan
        
        let layout = StretchyHeaderCollectionViewLayout()
        layout.minimumInteritemSpacing = 50.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        
        title = "Preview Plan"
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PreviewPlanViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = .white
        collectionView!.register(PlanProfileCollectionViewCell.self, forCellWithReuseIdentifier: "PlanProfileCollectionViewCell")
        
        collectionView!.register(PlanProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PlanProfileHeaderView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
//extension PlanProfileViewController {
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let row = indexPath.row
//        
//        //collectionView.registerClass(modelView.cellClass, forCellWithReuseIdentifier: modelView.cellID)
//        
//        let cell: PlanProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanProfileCollectionViewCell", for: indexPath) as! PlanProfileCollectionViewCell
//        cell.dataSource = dataSource
//        cell.delegate = self
//        
//        return cell
//    }
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
//        profileHeaderViewModel.presentingViewController = self
//        profileHeaderViewModel.planProfileHeaderViewModelDelegate = self
//        
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlanProfileHeaderView", for: indexPath) as! PlanProfileHeaderView
//        header.setupWith(profileHeaderViewModel)
//        
//        return header
//    }
//}
//extension PlanProfileViewController: UICollectionViewDelegateFlowLayout {
//    
//    private static var cellHeightCache: [String: CGSize] = [:]
//    func updateFlowLayoutIfNeeded(forceReload: Bool = false) {
//        guard let collectionView = collectionView else {
//            return
//        }
//        
//        let width = collectionView.bounds.width
//        
//        let headerHeight: CGFloat
//        
//        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
//        
//        let header = PlanProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
//        header.setupWith(profileHeaderViewModel)
//        headerHeight = header.systemLayoutHeightForWidth(width: width)
//        
//        if forceReload || stretchyFlowLayout.headerReferenceSize.height != headerHeight {
//            stretchyFlowLayout.headerReferenceSize = CGSize(width: width, height: headerHeight)
//            stretchyFlowLayout.invalidateLayout()
//            
//            collectionView.reloadData()
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if let referenceSize = PlanProfileViewController.cellHeightCache["Header"] {
//            return referenceSize
//        }
//        let width = collectionView.bounds.width
//        
//        let profileHeaderViewModel = PlanProfileHeaderViewModel(plan: plan, planNavigationState: planNavigationState, planNavigationDelegate: self)
//        
//        let header = PlanProfileHeaderView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
//        header.setupWith(profileHeaderViewModel)
//        
//        let height = header.systemLayoutHeightForWidth(width: width)
//        
//        let size = CGSize(width: width, height: ceil(height))
//        
//        PlanProfileViewController.cellHeightCache["Header"] = size
//        
//        return size
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.bounds.width
//        let cell = PlanProfileCollectionViewCell.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 200)))
//        cell.dataSource = dataSource
//        
//        let height = cell.getTableViewHeight()
//        
//        let size = CGSize(width: width, height: ceil(height))
//        
//        return size
//    }
//}
