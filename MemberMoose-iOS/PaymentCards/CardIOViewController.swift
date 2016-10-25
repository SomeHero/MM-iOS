//
//  CardIOViewController.swift
//  ShopperApp
//
//  Created by James Rhodes on 5/18/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Stripe

protocol CardCaptureDelegate: class {
    func didCompleteCardCapture(stpCard: STPCardParams)
    func didCancelCardCapture()
}
class CardIOViewController: UIViewController {
    var scanViewController: CardIOPaymentViewController?
    weak var cardCaptureDelegate: CardCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        CardIOUtilities.preload()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func scanCard() {
        scanViewController = CardIOPaymentViewController(paymentDelegate: self)
        scanViewController?.useCardIOLogo = true
        presentViewController(scanViewController!, animated: true, completion: nil)
    }
}
extension CardIOViewController: CardIOPaymentViewControllerDelegate {
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        self.cardCaptureDelegate?.didCancelCardCapture()
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let stpCard = STPCardParams()
            stpCard.number = info.cardNumber
            stpCard.expMonth = info.expiryMonth
            stpCard.expYear = info.expiryYear
            stpCard.cvc = info.cvv
            
            self.cardCaptureDelegate?.didCompleteCardCapture(stpCard)
        }
    }
}

