//
//  PlanAmountViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/2/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

protocol PlanAmountEditorDelegate: class {
    func didSubmitAmount(amount: String, interval: RecurringInterval)
}
class PlanAmountEditorViewController: UIViewController {
    var activeField: UITextField?
    
    private var amount: Double
    var interval:RecurringInterval?
    weak var planAmountEditorDelegate: PlanAmountEditorDelegate?

    fileprivate lazy var scrollView: UIScrollView = {
        let _scroll = UIScrollView()
        self.view.addSubview(_scroll)
        
        return _scroll
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.amountTextField, self.intervalTextField])
        stack.axis = .vertical
        stack.spacing = 40
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    fileprivate lazy var amountTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Amount", tag: 101)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.keyboardType = UIKeyboardType.decimalPad
        self.configureTextField(_textField.textField)
        
        //_textField.textField.addTarget(self, action: #selector(PlanAmountEditorViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var intervalTextField: StackViewInputField = {
        let _textField = StackViewInputField()
        _textField.configure("", placeholder: "Recurring Interval", tag: 101)
        _textField.textField.autocorrectionType = .no
        _textField.textField.autocapitalizationType = .none
        _textField.textField.inputView = self.intervalPicker
        _textField.textField.clearButtonMode = .never
        self.configureTextField(_textField.textField)
        
        //_textField.textField.addTarget(self, action: #selector(PlanAmountEditorViewController.validateForm), for: UIControlEvents.editingChanged)
        return _textField
    }()
    fileprivate lazy var intervalPicker: UIPickerView = {
        let _picker = UIPickerView()
        _picker.delegate = self
        _picker.dataSource = self
        
        return _picker
    }()
    init(title: String, amount: Double, interval: RecurringInterval?) {
        self.amount = amount
        self.interval = interval
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.textField.text = USD(amount).amount.stringValue
        intervalTextField.textField.text = interval?.description
        
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanAmountEditorViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(PlanAmountEditorViewController.saveClicked(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountTextField.textField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        stackView.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(view).inset(20)
        }
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        })
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        textField.delegate = self
        
        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    func saveClicked(_ sender: UIButton) {
        guard let recurringInterval = interval else {
            return
        }
        planAmountEditorDelegate?.didSubmitAmount(amount: amountTextField.textField.text!, interval: recurringInterval)
    }
}
extension PlanAmountEditorViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension PlanAmountEditorViewController : InputNavigationDelegate {
    func keyboardDidAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.2, animations: {
                let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
            })
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
        resetScrollViewInsets()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gotoPreviousInput() {
        if let activeField = activeField {
            let tag = activeField.tag
            
            let nextField = self.view.viewWithTag(tag-1)
            
            nextField?.becomeFirstResponder()
        }
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
    }
    
    func gotoNextInput() {
        if let activeField = activeField {
            let tag = activeField.tag
            
            let nextField = self.view.viewWithTag(tag+1)
            
            nextField?.becomeFirstResponder()
        }
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
    }
    
    func toggleKeyboardNavButtonsEnabled(_ toolBar: UIToolbar) {
        if let items = toolBar.items {
            let isLastItem = activeField == intervalTextField.textField
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == amountTextField.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
extension PlanAmountEditorViewController: UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}
extension PlanAmountEditorViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RecurringInterval(rawValue: row)?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let recurringInterval = RecurringInterval(rawValue: row) {
            interval = recurringInterval
            intervalTextField.textField.text = recurringInterval.description
            
        }
    }
}
