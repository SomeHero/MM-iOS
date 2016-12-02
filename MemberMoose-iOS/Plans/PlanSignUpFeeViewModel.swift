//
//  PlanSignUpFeeViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Money

protocol PlanSignUpFeeDelegate: class {
    func didUpdateSignUpFee(text: String)
}
class PlanSignUpFeeViewModel:DataSourceItemProtocol {
    weak var planSignUpFeeDelegate: PlanSignUpFeeDelegate?

    var cellID: String = "PlanSignUpFeeCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanNameCell.self
    
    var signUpFee: Double?
    
    init(plan: Plan) {
        if let oneTimeAmount = plan.oneTimeAmount {
            self.signUpFee = oneTimeAmount
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanSignUpFeeCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = 0.00
        
        if let amount = signUpFee {
            text = amount
        }
        let oneTimeSignUpFeeEditorViewController = OneTimeSignUpFeeEditorViewController(title: "Recurring Amount", amount: text)
        oneTimeSignUpFeeEditorViewController.oneTimeSignUpFeeEditorDelegate = self
        
        viewController.navigationController?.pushViewController(oneTimeSignUpFeeEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("One-Time Signup Fee")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension PlanSignUpFeeViewModel: OneTimeSignUpFeeEditorDelegate {
    func didSubmitAmount(amount: String) {
        planSignUpFeeDelegate?.didUpdateSignUpFee(text: amount)
    }
}
