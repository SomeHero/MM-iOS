//
//  Validator.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

struct Validator {
    static func isValidEmail(email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    static func isValidText(value: String) -> Bool {
        return !value.isEmpty
    }
    static func isValidZipCode(zipCode: String) -> Bool {
        return zipCode.characters.count > 4
    }
}