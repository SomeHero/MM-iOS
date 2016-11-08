//
//  ChargeViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class ChargeViewModel:DataSourceItemProtocol {
    var cellID: String = "ChargeCellIdentifier"
    var cellClass: UITableViewCell.Type = ChargeCell.self
    
    let totalCellHeight: CGFloat
    weak var delegate: ChargeCellDelegate?
    
    init(totalCellHeight: CGFloat, chargeCellDelegate: ChargeCellDelegate? = nil) {
        self.totalCellHeight = totalCellHeight
        self.delegate = chargeCellDelegate
    }
    @objc func dequeueAndConfigure(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ChargeCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        cell.delegate = delegate
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
}
