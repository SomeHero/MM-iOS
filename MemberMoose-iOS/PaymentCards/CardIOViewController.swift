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
    func didCompleteCardCapture(_ stpCard: STPCardParams)
    func didCancelCardCapture()
}
class CardIOViewController: UIViewController {
    var scanViewController: CardIOPaymentViewController?
    weak var cardCaptureDelegate: CardCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CardIOUtilities.preload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func scanCard() {
        scanViewController = CardIOPaymentViewController(paymentDelegate: self)
        scanViewController?.useCardIOLogo = true
        present(scanViewController!, animated: true, completion: nil)
    }
}
extension CardIOViewController: CardIOPaymentViewControllerDelegate {
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        self.cardCaptureDelegate?.didCancelCardCapture()
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
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

