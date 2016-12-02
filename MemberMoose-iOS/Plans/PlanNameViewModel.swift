//
//  PlanNameViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanNameDelegate: class {
    func didUpdatePlanName(text: String)
}
class PlanNameViewModel:DataSourceItemProtocol {
    weak var planNameDelegate: PlanNameDelegate?
    
    var cellID: String = "PlanNameCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanNameCell.self
    
    let name: String?
    
    init(plan: Plan) {
        self.name = plan.name
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanNameCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = ""
        
        if let name = name {
            text = name
        }
        let textEditorViewController = TextEditorViewController(title: "Plan Name", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Plan Name")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension PlanNameViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        planNameDelegate?.didUpdatePlanName(text: text)
    }
}
