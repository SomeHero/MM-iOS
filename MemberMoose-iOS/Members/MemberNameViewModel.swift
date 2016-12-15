//
//  MemberNameViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

protocol MemberNameDelegate: class {
    func didUpdateMemberName(text: String)
}
class MemberNameViewModel:DataSourceItemProtocol {
    weak var memberNameDelegate: MemberNameDelegate?
    
    var cellID: String = "MemberNameCellIdentifier"
    var cellClass: UITableViewCell.Type = MemberNameCell.self
    
    var name: String?
    
    init(member: User) {
        if let firstName = member.firstName, let lastName = member.lastName {
            self.name = "\(firstName) \(lastName)"
        }
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MemberNameCell else {
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
        let textEditorViewController = TextEditorViewController(title: "Member Name", text: text)
        textEditorViewController.textEditorDelegate = self
        
        viewController.navigationController?.pushViewController(textEditorViewController, animated: true)
    }
    @objc func viewForHeader() -> UIView? {
        let header = PlanHeaderView()
        header.setup("Member Name")
        
        return header
    }
    @objc func heightForHeader() -> CGFloat {
        return 50
    }
}
extension MemberNameViewModel: TextEditorDelegate {
    func didSubmitText(text: String) {
        memberNameDelegate?.didUpdateMemberName(text: text)
    }
}
