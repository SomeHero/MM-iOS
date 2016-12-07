//
//  FreeTrialPeriodViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol FreeTrialPeriodDelegate: class {
    func didUpdateFreeTrialPeriod(days: Int)
}
class FreeTrialPeriodViewModel:DataSourceItemProtocol {
    weak var freeTrialPeriodDelegate: FreeTrialPeriodDelegate?
    
    var cellID: String = "FreeTrialPeriodCellIdentifier"
    var cellClass: UITableViewCell.Type = FreeTrialPeriodCell.self
    
    let trialPeriodDays: Int
    
    init(plan: Plan) {
        self.trialPeriodDays = plan.trialPeriodDays
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FreeTrialPeriodCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        let text = String(trialPeriodDays)
        
        let textEditorViewController = TextEditorViewController(title: "Free Trial Period", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Free Trial Period")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension FreeTrialPeriodViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        if let days = Int(text) {
            freeTrialPeriodDelegate?.didUpdateFreeTrialPeriod(days: days)
        }
    }
}
