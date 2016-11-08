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
    func didChargeAmount(_ amount: USD)
}
class ChargeCell: UITableViewCell {
    fileprivate var amount = USD(0.0)
    weak var delegate: ChargeCellDelegate?
    
    fileprivate lazy var amountToolbar: UIView = {
        let _view = UIView()

        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var amountLabel: UILabel = {
        let _label = UILabel()
        _label.backgroundColor = .white
        _label.textAlignment = .right
        _label.font = UIFontTheme.Regular(.xLarge)
        
        self.amountToolbar.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColorTheme.NavBarLineView
        
        self.contentView.addSubview(lineView)
        
        return lineView
    }()
    fileprivate lazy var keyboard: CalculatorKeyPadView = {
        let _keyBoard = CalculatorKeyPadView()
        _keyBoard.delegate = self
        
        self.contentView.addSubview(_keyBoard)
        
        return _keyBoard
    }()
    fileprivate lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
    
        return formatter
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        selectionStyle = .none
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func updateConstraints() {
        amountToolbar.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(60)
        }
        amountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(amountToolbar).inset(10)
            make.top.bottom.equalTo(amountToolbar)
        }
        lineView.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(amountToolbar.snp.bottom)
            make.height.equalTo(1)
        }
        keyboard.snp.updateConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }

        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? ChargeViewModel {
            amountLabel.text = "\(amount)"
            
            keyboard.snp.updateConstraints { (make) in
                make.height.equalTo(viewModel.totalCellHeight-60-1)
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
}
extension ChargeCell: CalculatorKeyPadViewDelegate {
    func didClickNumber(_ number: Int) {
        amount = USD(amount*10) + USD(Double(number)/Double(100.0))
        
        amountLabel.text = "\(amount.description)"
    }
    func didClickSend() {
        delegate?.didChargeAmount(amount)
        
        amount = 0
    }
}

