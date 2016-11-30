//
//  PlanDescriptionViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanDescriptionDelegate: class {
    func didUpdatePlanDescription(text: String)
}
class PlanDescriptionViewModel:DataSourceItemProtocol {
    weak var planDescriptionDelegate: PlanDescriptionDelegate?
    
    var cellID: String = "PlanDescriptionCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanDescriptionCell.self
    
    let description: String?
    
    init(plan: Plan) {
        self.description = plan.description
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanDescriptionCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = ""
        
        if let description = description {
            text = description
        }
        let textEditorViewController = TextEditorViewController(title: "Plan Description", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Description")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension PlanDescriptionViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        planDescriptionDelegate?.didUpdatePlanDescription(text: text)
    }
}
