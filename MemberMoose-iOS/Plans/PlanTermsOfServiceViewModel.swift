//
//  PlanTermsOfServiceViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol PlanTermsOfServiceDelegate: class {
    func didUpdateTermsOfService(text: String)
}
class PlanTermsOfServiceViewModel:DataSourceItemProtocol {
    weak var planTermsOfServiceDelegate: PlanTermsOfServiceDelegate?
    
    var cellID: String = "PlanTermsOfServiceCellIdentifier"
    var cellClass: UITableViewCell.Type = PlanDescriptionCell.self
    
    let termsOfService: String?
    
    init(plan: Plan) {
        self.termsOfService = plan.termsOfService
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PlanTermsOfServiceCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = ""
        
        if let termsOfService = termsOfService {
            text = termsOfService
        }
        let textEditorViewController = TextEditorViewController(title: "Terms of Service", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Terms of Service")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension PlanTermsOfServiceViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        planTermsOfServiceDelegate?.didUpdateTermsOfService(text: text)
    }
}
