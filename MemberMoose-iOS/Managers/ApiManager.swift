//
//  ApiManager.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

public struct AuthenticateUser {
    let emailAddress: String
    let password: String
    
    public init(emailAddress: String, password: String) {
        self.emailAddress = emailAddress
        self.password = password
    }
    func parameterize() -> [String : AnyObject] {
        let parameters = [
            "email_address": emailAddress,
            "password": password
        ]
        
        return parameters
    }
}
public struct CreateUser {
    let emailAddress: String
    let password: String
    let companyName: String
    let avatar: UIImage?
    
    public init(emailAddress: String, password: String, companyName: String, avatar: UIImage? = nil) {
        self.emailAddress = emailAddress
        self.password = password
        self.companyName = companyName
        self.avatar = avatar
    }
    func parameterize() -> [String : AnyObject] {
        let parameters = [
            "email_address": emailAddress,
            "password": password,
            "company_name": companyName
        ]

        return parameters
    }
}
public struct UpdateUser {
    let userId: String
    let firstName: String
    let lastName: String
    let emailAddress: String
    var password: String?
    let avatar: UIImage?
    
    public init(userId: String, firstName: String, lastName: String, emailAddress: String, avatar: UIImage? = nil) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.avatar = avatar
    }
    func parameterize() -> [String : AnyObject] {
        var parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email_address": emailAddress,
            ]
        if let password = password {
            parameters["password"] = password
        }
        
        return parameters
    }
}
public struct ConnectStripe {
    let userId: String
    let stripeParams: [String: AnyObject]
    
    public init(userId: String, stripeParams: [String: AnyObject]) {
        self.userId = userId
        self.stripeParams = stripeParams
    }
    func parameterize() -> [String: AnyObject] {
        let parameters = [
            "stripe_connect": stripeParams
        ]
        
        return parameters
    }
}
public struct CreatePlan {
    let name: String
    let amount: Double
    let interval: String
    let intervalCount: Int
    let statementDescriptor: String
    let trialPeriodDays: Int
    let statementDescription: String
    
    public init(name: String, amount:Double, interval: String, intervalCount: Int, statementDescriptor: String, trialPeriodDays: Int, statementDescription: String) {
        self.name = name
        self.amount = amount
        self.interval = interval
        self.intervalCount = intervalCount
        self.statementDescriptor = statementDescriptor
        self.trialPeriodDays = trialPeriodDays
        self.statementDescription = statementDescription
    }
    func parameterize() -> [String: AnyObject] {
        let parameters: [String: AnyObject] = [
            "name": name,
            "amount": amount,
            "interval": interval,
            "interval_count": intervalCount,
            "statement_descriptor": statementDescriptor,
            "trial_period_days": trialPeriodDays,
            "statement_description": statementDescription
        ]
        
        return parameters
    }
}
public struct CreateMember {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    public init(firstName: String, lastName: String, emailAddress: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
    }
    func parameterize() -> [String: AnyObject] {
        let parameters: [String: AnyObject] = [
            "first_name": firstName,
            "last_name": lastName,
            "email_address": emailAddress
        ]
        
        return parameters
    }
}
public class ApiManager {
    private var kApiBaseUrl:String?
    public var apiBaseUrl: String {
        set {
            kApiBaseUrl = newValue
        }
        get {
            if let kApiBaseUrl = kApiBaseUrl {
                return kApiBaseUrl
            } else {
                fatalError("API Base URL must be set")
            }
        }
    }
    public var token: String?
    public static let sharedInstance = ApiManager()
    
    private init() {}
    
    private var headers: [String: String]? {
        var headers: [String: String] = [:]
        
        if let token = token {
            headers["x-access-token"] = token
        }
        
        return headers.count > 0 ? headers : nil;
    }
    public func authenticate(authenticateUser: AuthenticateUser, success: (userId: String, token: String) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = authenticateUser.parameterize()
        
        Alamofire.request(.POST,  apiBaseUrl + "sessions", parameters: params, encoding: .JSON)
            .validate()
            .responseJSON { response in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let result = response.result.value {
                    if let userId = result["user_id"] as? String, token = result["token"] as? String {
                        self.token = token
                        
                        success(userId: userId, token: token)
                    } else {
                        failure(error: nil, errorDictionary: nil)
                    }
                }  else {
                    failure(error: nil, errorDictionary: nil)
                }
        }
    }
    public func validateUserName(emailAddress:String, success: (isValid: Bool) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "users/\(emailAddress)", parameters: nil, encoding: .JSON, headers: headers)
            .response { response in
                if response.1?.statusCode == 200 {
                    success(isValid: false)
                } else {
                    success(isValid: true)
                }
        }
    }
    public func createUser(createUser: CreateUser, success: (userId: String, token: String) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createUser.parameterize()
        
        Alamofire.upload(.POST,  apiBaseUrl + "users", multipartFormData: {
            multipartFormData in
            
            if let avatar = createUser.avatar, imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
            }
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            },  encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON {
                        response in
                        
                        if let result = response.result.value {
                            if let userId = result["user_id"] as? String, token = result["token"] as? String {
                                self.token = token
                                
                                success(userId: userId, token: token)
                            } else {
                                failure(error: nil, errorDictionary: nil)
                            }
                        } else {
                            failure(error: nil, errorDictionary: nil)
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    public func updateUser(updateUser: UpdateUser, success: (response: User) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = updateUser.parameterize()

        Alamofire.upload(.PUT,  apiBaseUrl + "users/\(updateUser.userId)", headers: headers, multipartFormData: {
            multipartFormData in
            
            if let avatar = updateUser.avatar, imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
            }
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        },  encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .Success(let upload, _, _):
                upload
                    .validate()
                    .responseObject { (response: Response<User, NSError>) in
                        if let error = response.result.error {
                            var errorResponse: [String: AnyObject]? = [:]
                            
                            if let data = response.data {
                                do {
                                    errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                                } catch let error as NSError {
                                    failure(error: error, errorDictionary: nil)
                                } catch let error {
                                    failure(error: error, errorDictionary: nil)
                                }
                                failure(error: error, errorDictionary: errorResponse)
                            } else {
                                failure(error: error, errorDictionary: nil)
                            }
                        }
                        if let user = response.result.value {
                            success(response: user)
                        } else {
                            failure(error: nil, errorDictionary: nil)
                        }
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
        })
    }
    public func me(success: (response: User) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "me", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .responseObject { (response: Response<User, NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let user = response.result.value {
                    success(response: user)
                } else {
                    failure(error: nil, errorDictionary: nil)
                }
                
        }
    }
    public func connectStripe(connectStripe: ConnectStripe, success: (response: User) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = connectStripe.parameterize()
        
        Alamofire.request(.POST, apiBaseUrl + "users/\(connectStripe.userId)/connect_stripe", parameters: params, encoding: .JSON, headers: headers)
            .validate()
            .responseObject { (response: Response<User, NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let user = response.result.value {
                    success(response: user)
                }
        }

    }
    public func importPlans(userId: String, plansList: [String], success: (response: User) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params: [String: AnyObject] = ["plans": plansList]
        
        Alamofire.request(.POST, apiBaseUrl + "users/\(userId)/import_plans", parameters: params, encoding: .JSON, headers: headers)
            .validate()
            .responseObject { (response: Response<User, NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let user = response.result.value {
                    success(response: user)
                }
        }
    }
    public func getPlans(success: (response: [Plan]?) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "plans", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .responseArray { (response: Response<[Plan], NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        }
                        catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let plans = response.result.value {
                    success(response: plans)
                }
        }
        
    }
    public func getMembers(success: (response: [User]?) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "members", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .responseArray { (response: Response<[User], NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        }
                        catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let users = response.result.value {
                    success(response: users)
                }
        }
        
    }
    public func cancelSubscription(subscriptionId: String, success: ()  -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        
        Alamofire.request(.DELETE, apiBaseUrl + "subscriptions/\(subscriptionId)", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .response {  (request, response, data, error) in
                if let error = error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        }
                        catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                } else {
                    success()
                }
        }
    }
    public func createPlan(createPlan: CreatePlan, success: (response: Plan) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createPlan.parameterize()
        
        Alamofire.request(.POST, apiBaseUrl + "plans", parameters: params, encoding: .JSON, headers: headers)
            .validate()
            .responseObject { (response: Response<Plan, NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let plan = response.result.value {
                    success(response: plan)
                }
        }
    }
    public func createMember(createMember: CreateMember, success: (response: User) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createMember.parameterize()
        
        Alamofire.request(.POST, apiBaseUrl + "members", parameters: params, encoding: .JSON, headers: headers)
            .validate()
            .responseObject { (response: Response<User, NSError>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error: error, errorDictionary: nil)
                        } catch let error {
                            failure(error: error, errorDictionary: nil)
                        }
                        failure(error: error, errorDictionary: errorResponse)
                    } else {
                        failure(error: error, errorDictionary: nil)
                    }
                }
                if let user = response.result.value {
                    success(response: user)
                }
        }
    }
}
