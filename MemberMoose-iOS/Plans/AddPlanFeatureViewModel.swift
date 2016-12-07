//
//  AddPlanFeatureViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol AddPlanFeatureDelegate: class {
    func didAddPlanFeature(text: String)
}
class AddPlanFeatureViewModel:DataSourceItemProtocol {
    weak var addPlanFeatureDelegate: AddPlanFeatureDelegate?
    weak var presentingViewController: UIViewController?
    
    var cellID: String = "AddPlanFeaturesCellIdentifier"
    var cellClass: UITableViewCell.Type = AddPlanFeatureCell.self
    
    let feature: String
    weak var tableView: UITableView?
    weak var planFeaturesCell: PlanFeaturesCell?
    
    init(feature: String) {
        self.feature = feature
    }
    @objc func didSelectItem(viewController: UIViewController) {
        let textEditorViewController = TextEditorViewController(title: "Plan Feature", text: "")
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? AddPlanFeatureCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return 0
    }
}
extension AddPlanFeatureViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        addPlanFeatureDelegate?.didAddPlanFeature(text: text)
    }
}
