//
//  ChargeCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import StripeDashboardUI

class ChargeCell: UITableViewCell {

    private lazy var amountToolbar: UIView = {
        let _view = UIView()

        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var amountLabel: MoneyTextField = {
        let _label = MoneyTextField(amount: 0, currency: "USD")
        _label.numberColor = UIColorTheme.PrimaryFont
        _label.currencySymbolColor = UIColorTheme.PrimaryFont
        _label.backgroundColor = .whiteColor()
        _label.borderWidth = 0
//        _label.textAlignment = .Right
//        _label.font = UIFontTheme.Regular(.XLarge)
//        
        self.amountToolbar.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColorTheme.NavBarLineView
        
        self.contentView.addSubview(lineView)
        
        return lineView
    }()
    private lazy var keyboard: CalculatorKeyboard = {
        let _keyBoard = CalculatorKeyboard(frame: CGRect.zero)
        _keyBoard.delegate = self
        
        self.contentView.addSubview(_keyBoard)
        
        return _keyBoard
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        selectionStyle = .None
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func updateConstraints() {
        amountToolbar.snp_updateConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(60)
        }
        amountLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(amountToolbar).inset(10)
            make.top.bottom.equalTo(amountToolbar)
        }
        lineView.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(amountToolbar.snp_bottom)
            make.height.equalTo(1)
        }
        keyboard.snp_updateConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }

        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? ChargeViewModel {
            amountLabel.amount = 0
            
            keyboard.snp_updateConstraints { (make) in
                make.height.equalTo(viewModel.totalCellHeight-60-1)
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    func keyClicked(sender: UIButton) {
        amountLabel.amount = 100
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
}
extension ChargeCell: CalculatorDelegate {
    func calculator(calculator: CalculatorKeyboard, didChangeValue value: String) {
        amountLabel.amount = amountLabel.amount + UInt(value)!
    }
    func didContinue(calculator: CalculatorKeyboard) {
//        if let text = valueTextField.text, value = Double(text) {
//            calculatorOverlayDelegate?.didContinue(value)
//        }
    }
}

