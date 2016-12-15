//
//  MemberEmailAddressViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

protocol MemberEmailAddressDelegate: class {
    func didUpdateMemberEmailAddress(text: String)
}
class MemberEmailAddressViewModel:DataSourceItemProtocol {
    weak var memberEmailAddresssDelegate: MemberEmailAddressDelegate?
    
    var cellID: String = "MemberEmailAddressCellIdentifier"
    var cellClass: UITableViewCell.Type = MemberEmailAddressCell.self
    
    var emailAddress: String?
    
    init(member: User) {
        if let emailAddress = member.emailAddress {
            self.emailAddress = emailAddress
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MemberEmailAddressCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        
        return cell
    }
    @objc func didSelectItem(viewController: UIViewController) {
        var text = ""
        
        if let emailAddress = emailAddress {
            text = emailAddress
        }
        let textEditorViewController = TextEditorViewController(title: "Member Email Address", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Member Email Address")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension MemberEmailAddressViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        memberEmailAddresssDelegate?.didUpdateMemberEmailAddress(text: text)
    }
}
