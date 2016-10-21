//
//  PaymentCardViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

private enum FieldTags: Int {
    case ExpirationMonthPicker = 105
    case ExpirationYearPicker = 107
}
class PaymentCardViewController: UIViewController {
    var activeField: UITextField?
    private var paymentMethod: PaymentCard
    private var selectedMonth: Int?
    private var selectedYear: Int?
    
    private let monthes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    private lazy var years: [Int] = {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year], fromDate: date)
        
        let year =  components.year
        
        var years: [Int] = []
        
        for i in 0..<10 {
            years.append(year.advancedBy(i))
        }
        
        return years
    }()
    private lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.view.addSubview(_scrollView)
        
        return _scrollView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.nameOnCardView, self.cardNumberView, self.expirationView])
        stack.axis = .Vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    lazy var nameOnCardView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Name on Card", placeholder: "Name on Card", tag: 100)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    lazy var cardNumberView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Card Number", placeholder: "Card Number", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    lazy var expirationView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.expirationMonthView, self.expirationYearView])
        stack.axis = .Horizontal
        stack.spacing = 10
        stack.distribution = .FillEqually
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    lazy var expirationMonthView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Expiration Month", placeholder: "Month", tag: 104)
        input.textField.autocapitalizationType = .None
        input.textField.inputView = self.monthPicker
        //input.textField.isPicker = true
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    lazy var monthPicker: UIPickerView = {
        let _picker = UIPickerView()
        _picker.tag = FieldTags.ExpirationMonthPicker.rawValue
        _picker.dataSource = self
        _picker.delegate = self
        
        return _picker
    }()
    lazy var expirationYearView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Expiration Year", placeholder: "Year", tag: 106)
        input.textField.autocapitalizationType = .None
        input.textField.inputView = self.yearPicker
        //input.textField.isPicker = true
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), forControlEvents: UIControlEvents.EditingChanged)
        return input
    }()
    lazy var yearPicker: UIPickerView = {
        let _picker = UIPickerView()
        _picker.tag = FieldTags.ExpirationYearPicker.rawValue
        _picker.dataSource = self
        _picker.delegate = self
        
        return _picker
    }()
    init(paymentMethod: PaymentCard) {
        self.paymentMethod = paymentMethod
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Payment Method"
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(PaymentCardViewController.savePaymentMethod))
        
        navigationItem.rightBarButtonItem = saveButton
        
        self.view.backgroundColor = UIColor.whiteColor()

        if let nameOnCard = paymentMethod.nameOnCard {
            nameOnCardView.textField.text = nameOnCard
        } else {
            if let user = SessionManager.sharedUser, firstName = user.firstName, lastName = user.lastName {
                nameOnCardView.textField.text = "\(firstName) \(lastName)"
            }
        }
        //cardTypeView.valueLabel.text = paymentMethod.cardType
        //cardNumberView.textField.text = "XXXX-XXXX-XXXX-\(paymentMethod.cardLastFour)"
        if let index = monthes.indexOf({$0 == paymentMethod.expirationMonth}) {
            setSelectedMonth(monthes[index])
        }
        if let index = years.indexOf({$0 == paymentMethod.expirationYear}) {
            setSelectedYear(years[index])
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PaymentCardViewController.keyboardDidAppear(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PaymentCardViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackView.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.width).inset(20*2)
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        
        super.viewDidLayoutSubviews()
    }
    func configureTextField(textField: UITextField) {
        textField.returnKeyType = .Next
        textField.delegate = self
        
        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func resetScrollViewInsets() {
        UIView.animateWithDuration(0.2) {
            let contentInsets = UIEdgeInsetsZero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    func validateForm() {
        
    }
    func savePaymentMethod() {
//        guard let user = SessionManager.sharedUser else {
//            return
//        }
//        guard let expirationMonth = selectedMonth, expirationYear = selectedYear else {
//            return
//        }
//        SVProgressHUD.show()
//        
//        let updatePaymentMethod = UpdatePaymentMethod(userId: user.id, paymentMethodId: paymentMethod.id, expirationMonth: expirationMonth, expirationYear: expirationYear)
//        
//        ApiManager.sharedInstance.updatePaymentCard(updatePaymentMethod, success: { [weak self] (response) in
//            SVProgressHUD.dismiss()
//            
//            guard let _self = self else {
//                return
//            }
//            if let index = (user.paymentMethods.indexOf { $0.id == _self.paymentMethod.id }) {
//                user.paymentMethods[index] = response
//            }
//            _self.navigationController?.popViewControllerAnimated(true)
//            
//        }) { [weak self] (error, errorDictionary) in
//            SVProgressHUD.dismiss()
//            
//            guard let _self = self else {
//                return
//            }
//            ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
//        }
    }
    func setSelectedMonth(month: Int) {
        selectedMonth = month
        expirationMonthView.textField.text = String(month)
    }
    func setSelectedYear(year: Int) {
        selectedYear = year
        expirationYearView.textField.text = String(year)
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}
extension PaymentCardViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension PaymentCardViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case FieldTags.ExpirationMonthPicker.rawValue:
            return monthes.count
        default:
            return years.count
        }
    }
}
extension PaymentCardViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case FieldTags.ExpirationMonthPicker.rawValue:
            return String(monthes[row])
        default:
            return String(years[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case FieldTags.ExpirationMonthPicker.rawValue:
            setSelectedMonth(monthes[row])
        default:
            setSelectedYear(years[row])
        }
    }
}
extension PaymentCardViewController : InputNavigationDelegate {
    func keyboardDidAppear(notification: NSNotification) {
        if let info = notification.userInfo {
            if let keyboardSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size {
                let keyboardHeight = keyboardSize.height
                
                UIView.animateWithDuration(0.2) {
                    let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
                    self.scrollView.contentInset = contentInsets
                    self.scrollView.scrollIndicatorInsets = contentInsets
                }
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
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
    
    func toggleKeyboardNavButtonsEnabled(toolBar: UIToolbar) {
        if let items = toolBar.items {
            let isLastItem = activeField == expirationMonthView
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].enabled = !isLastItem
            
            let isFirstItem = activeField == nameOnCardView.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].enabled = !isFirstItem
        }
    }
}
