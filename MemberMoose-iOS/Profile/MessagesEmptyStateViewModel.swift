//
//  MessagesEmptyStateViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/17/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class MessagesEmptyStateViewModel:DataSourceItemProtocol {
    var cellID: String = "MessagesEmptyStateCellIdentifier"
    var cellClass: UITableViewCell.Type = MessagesEmptyStateCell.self
    
    let logo: String
    let header: String
    let subHeader: String

    init(logo: String, header: String, subHeader: String) {
        self.logo = logo
        self.header = header
        self.subHeader = subHeader
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessagesEmptyStateCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)

        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
