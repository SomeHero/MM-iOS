//
//  ChargeCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

protocol ChargeCellDelegate: class {
    func didChargeAmount(amount: USD)
}
class ChargeCell: UITableViewCell {
    private var amount = USD(0.0)
    weak var delegate: ChargeCellDelegate?
    
    private lazy var amountToolbar: UIView = {
        let _view = UIView()

        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var amountLabel: UILabel = {
        let _label = UILabel()
        _label.backgroundColor = .whiteColor()
        _label.textAlignment = .Right
        _label.font = UIFontTheme.Regular(.XLarge)
        
        self.amountToolbar.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColorTheme.NavBarLineView
        
        self.contentView.addSubview(lineView)
        
        return lineView
    }()
    private lazy var keyboard: CalculatorKeyPadView = {
        let _keyBoard = CalculatorKeyPadView()
        _keyBoard.delegate = self
        
        self.contentView.addSubview(_keyBoard)
        
        return _keyBoard
    }()
    private lazy var currencyFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .CurrencyStyle
    
        return formatter
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
            amountLabel.text = "\(amount)"
            
            keyboard.snp_updateConstraints { (make) in
                make.height.equalTo(viewModel.totalCellHeight-60-1)
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
}
extension ChargeCell: CalculatorKeyPadViewDelegate {
    func didClickNumber(number: Int) {
        amount = USD(amount*10) + USD(Double(number)/Double(100.0))
        
        amountLabel.text = "\(amount.description)"
    }
    func didClickSend() {
        delegate?.didChargeAmount(amount)
        
        amount = 0
    }
}

