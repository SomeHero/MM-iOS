//
//  MemberEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

protocol MemberEmptyStateDelegate: class {
    func didCreateMember()
    func didSharePlan()
}
class MemberEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "MemberEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = MemberEmptyStateCell.self
    
    let logo: String
    let header: String
    let subHeader: String
    weak var memberEmptyStateDelegate: MemberEmptyStateDelegate?
    
    init(logo: String, header: String, subHeader: String, memberEmptyStateDelegate: MemberEmptyStateDelegate) {
        self.logo = logo
        self.header = header
        self.subHeader = subHeader
        self.memberEmptyStateDelegate = memberEmptyStateDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MemberEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.memberEmptyStateCellDelegate = self
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
extension MemberEmptyStateViewModel: MemberEmptyStateCellDelegate {
    func didCreateMemberClicked() {
        memberEmptyStateDelegate?.didCreateMember()
    }
    func didSharePlanClicked() {
        memberEmptyStateDelegate?.didSharePlan()
    }
}
