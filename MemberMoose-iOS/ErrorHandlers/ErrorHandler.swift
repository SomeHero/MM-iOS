//
//  ErrorHandler.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/27/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//
import Foundation

struct HumanReadableErrorMessage {
    static func translateMinorCode(minorCode: Int) -> String {
        switch minorCode {
        case 1001:
            return "The email address/password was not found.  Please try again."
        case 1002:
            return "Sorry, it looks like that email address already has an MemberMoose account."
        case 1003:
            return "Your password must be atleast 6 characters."
        case 1004:
            return "Sorry, we're unable to find your user.  Please try again or join MemberMoose."
        case 1005:
            return "Sorry, it doesn't look like your credentials checked out.  Please try again."
        case 1006:
            return "Sorry, we were unable to log you in.  Please try again."

            
        default:
            return "Sorry an error occurred.  Please try again."
        }
    }
}
class ErrorHandler {
    static func presentErrorDialog(presentingViewController: UIViewController, title: String, message: String) {
        print("unknown error occurred")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentingViewController.presentViewController(alert, animated: true, completion: nil)
    }
    static func presentErrorDialog(presentingViewController: UIViewController) {
        print("unknown error occurred")
        
        ErrorHandler.presentErrorDialog(presentingViewController, title: "An Error Occurred", message: "Sorry, something happened.  Please try again.")
    }
    static func presentErrorDialog(presentingViewController: UIViewController, error: ErrorType?) {
        if let error = error {
            print("an error occured: \(error)")
        } else {
            print("unknown error occurred")
        }
        
        ErrorHandler.presentErrorDialog(presentingViewController, title: "An Error Occurred", message: "Sorry, something happened.  Please try again.")
    }
    static func presentErrorDialog(presentingViewController: UIViewController, error: ErrorType?, errorDictionary: [String: AnyObject]?) {
        if let error = error {
            print("an error occured: \(error)")
        } else {
            print("unknown error occurred")
        }
        
        if let errorDictionary = errorDictionary, minorCode = errorDictionary["minor_code"] as? Int {
            ErrorHandler.presentErrorDialog(presentingViewController, title: "An Error Occurred", message: HumanReadableErrorMessage.translateMinorCode(minorCode))
        } else {
            ErrorHandler.presentErrorDialog(presentingViewController, title: "An Error Occurred", message: HumanReadableErrorMessage.translateMinorCode(0))
        }
    }
    static func parseHumanReadableErrorMessage(errorDictionary: [String: AnyObject]) -> String {
        var humanReadableErrorMessage: String = ""
        
        if let minorCode = errorDictionary["minor_code"] as? Int {
            humanReadableErrorMessage = HumanReadableErrorMessage.translateMinorCode(minorCode)
        } else {
            humanReadableErrorMessage = "Sorry, an error occurred.  Please try again."
        }
        
        return humanReadableErrorMessage
    }
}

