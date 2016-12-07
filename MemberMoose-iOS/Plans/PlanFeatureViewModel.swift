    //
//  PlanFeatureViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanFeatureDelegate: class {
    func didUpdatePlanFeature(text: String, index: Int)
}
class PlanFeatureViewModel:DataSourceItemProtocol {
    weak var planFeatureDelegate: PlanFeatureDelegate?
    weak var presentingViewController: UIViewController?
    
    var cellID: String = "PlanFeatureCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanFeatureCell.self
    
    let feature: String
    let index: Int
    
    init(feature: String, index: Int) {
        self.feature = feature
        self.index = index
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanFeatureCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        let textEditorViewController = TextEditorViewController(title: "Feature", text: feature)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return 0
    }
}
extension PlanFeatureViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        planFeatureDelegate?.didUpdatePlanFeature(text: text, index: index)
    }
}
