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
    weak var calculatorKeyboardDelgate: CalculatorKeyPadViewDelegate?
    
    init(totalCellHeight: CGFloat, calculatorKeyboardDelgate: CalculatorKeyPadViewDelegate? = nil) {
        self.totalCellHeight = totalCellHeight
        self.calculatorKeyboardDelgate = calculatorKeyboardDelgate
    }
    @objc func dequeueAndConfigure(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as? ChargeCell else {
            fatalError(#function)
        }
        
        cell.setupWith(self)
        //cell.calculatorKeyboardDelgate = calculatorKeyboardDelgate
        
        return cell
    }
    @objc func viewForHeader() -> UIView? {
        return nil
    }
    @objc func heightForHeader() -> CGFloat {
        return CGFloat.min;
    }
}
