//
//  PaymentCardViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD
import Stripe

private enum FieldTags: Int {
    case expirationMonthPicker = 105
    case expirationYearPicker = 107
}
class PaymentCardViewController: UIViewController {
    let user: User
    var activeField: UITextField?
    fileprivate var paymentMethod: PaymentCard?
    fileprivate var selectedMonth: Int?
    fileprivate var selectedYear: Int?
    
    fileprivate let monthes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    fileprivate lazy var years: [Int] = {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year], from: date)
        
        let year =  components.year
        
        var years: [Int] = []
        
        for i in 0..<10 {
            years.append((year?.advanced(by: i))!)
        }
        
        return years
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let _scrollView         = UIScrollView()
        
        self.view.addSubview(_scrollView)
        
        return _scrollView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.nameOnCardView, self.cardNumberView, self.expirationView])
        stack.axis = .vertical
        stack.spacing = 10
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    lazy var nameOnCardView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Name on Card", placeholder: "Name on Card", tag: 100)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    lazy var cardNumberView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Card Number", placeholder: "Card Number", tag: 101)
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    lazy var expirationView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.expirationMonthView, self.expirationYearView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        self.scrollView.addSubview(stack)
        return stack
    }()
    lazy var expirationMonthView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Expiration Month", placeholder: "Month", tag: 104)
        input.textField.autocapitalizationType = .none
        input.textField.inputView = self.monthPicker
        //input.textField.isPicker = true
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    lazy var monthPicker: UIPickerView = {
        let _picker = UIPickerView()
        _picker.tag = FieldTags.expirationMonthPicker.rawValue
        _picker.dataSource = self
        _picker.delegate = self
        
        return _picker
    }()
    lazy var expirationYearView: StackViewInputField = {
        let input = StackViewInputField()
        input.configure("", label: "Expiration Year", placeholder: "Year", tag: 106)
        input.textField.autocapitalizationType = .none
        input.textField.inputView = self.yearPicker
        //input.textField.isPicker = true
        self.configureTextField(input.textField)
        
        input.textField.addTarget(self, action: #selector(PaymentCardViewController.validateForm), for: UIControlEvents.editingChanged)
        return input
    }()
    lazy var yearPicker: UIPickerView = {
        let _picker = UIPickerView()
        _picker.tag = FieldTags.expirationYearPicker.rawValue
        _picker.dataSource = self
        _picker.delegate = self
        
        return _picker
    }()
    init(user: User, paymentMethod: PaymentCard? = nil) {
        self.user = user
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
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(PaymentCardViewController.savePaymentMethod))
        
        navigationItem.rightBarButtonItem = saveButton
        
        self.view.backgroundColor = UIColor.white

        if let paymentMethod = paymentMethod {
            if let nameOnCard = paymentMethod.nameOnCard {
                nameOnCardView.textField.text = nameOnCard
            } else {
                if let user = SessionManager.sharedUser, let firstName = user.firstName, let lastName = user.lastName {
                    nameOnCardView.textField.text = "\(firstName) \(lastName)"
                }
            }
            //cardTypeView.valueLabel.text = paymentMethod.cardType
            //cardNumberView.textField.text = "XXXX-XXXX-XXXX-\(paymentMethod.cardLastFour)"
            if let index = monthes.index(where: {$0 == paymentMethod.expirationMonth}) {
                setSelectedMonth(monthes[index])
            }
            if let index = years.index(where: {$0 == paymentMethod.expirationYear}) {
                setSelectedYear(years[index])
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentCardViewController.keyboardDidAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentCardViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackView.snp.updateConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width).inset(20*2)
            make.top.equalTo(scrollView).inset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(scrollView).inset(20)
        }
        
        super.viewDidLayoutSubviews()
    }
    func configureTextField(_ textField: UITextField) {
        textField.returnKeyType = .next
        textField.delegate = self
        
        let toolBar = KeyboardDecorator.getInputToolbarWithDelegate(self)
        textField.inputAccessoryView = toolBar
    }
    func resetScrollViewInsets() {
        UIView.animate(withDuration: 0.2, animations: {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }) 
    }
    func validateForm() {
        
    }
    func savePaymentMethod() {
        guard let cardNumber = cardNumberView.textField.text, let expMonthString = expirationMonthView.textField.text, let expMonth = UInt(expMonthString), let expYearString = expirationYearView.textField.text, let expYear = UInt(expYearString) else {
            return
        }
        let stpCard = STPCardParams()
        stpCard.number = cardNumber
        stpCard.expMonth = expMonth
        stpCard.expYear = expYear
        stpCard.cvc = "111"

        STPAPIClient.shared().createToken(withCard: stpCard, completion: { [weak self] (token, error) in
            
            guard let _self = self else {
                return
            }
            if let error = error {
                ErrorHandler.presentErrorDialog(_self, error: error)
            } else if let token = token {
                let addPaymentCard = AddPaymentCard(user: _self.user, stripeToken: token.tokenId)
                ApiManager.sharedInstance.addPaymentCard(addPaymentCard, success: { [weak self] (response) in
                    guard let _self = self else {
                        return
                    }
                    _self.user.paymentCards.append(response)
                    
                    let _ =  _self.navigationController?.popViewController(animated: true)
                }, failure: { [weak self] (error, errorDictionary) in
                    guard let _self = self else {
                        return
                    }
                    ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                })
            }
        })

    }
    func setSelectedMonth(_ month: Int) {
        selectedMonth = month
        expirationMonthView.textField.text = String(month)
    }
    func setSelectedYear(_ year: Int) {
        selectedYear = year
        expirationYearView.textField.text = String(year)
    }
    func backClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
}
extension PaymentCardViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let toolBar = activeField?.inputAccessoryView as? UIToolbar {
            toggleKeyboardNavButtonsEnabled(toolBar)
        }
        return true
    }
}
extension PaymentCardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case FieldTags.expirationMonthPicker.rawValue:
            return monthes.count
        default:
            return years.count
        }
    }
}
extension PaymentCardViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case FieldTags.expirationMonthPicker.rawValue:
            return String(monthes[row])
        default:
            return String(years[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case FieldTags.expirationMonthPicker.rawValue:
            setSelectedMonth(monthes[row])
        default:
            setSelectedYear(years[row])
        }
    }
}
extension PaymentCardViewController : InputNavigationDelegate {
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
            let isLastItem = activeField == expirationMonthView
            let nextButtonIndex = KeyboardDecorator.nextIndex
            items[nextButtonIndex].isEnabled = !isLastItem
            
            let isFirstItem = activeField == nameOnCardView.textField
            let previousButtonIndex = KeyboardDecorator.previousIndex
            items[previousButtonIndex].isEnabled = !isFirstItem
        }
    }
}
