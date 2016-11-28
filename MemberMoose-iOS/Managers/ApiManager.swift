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
    func parameterize() -> [String : String] {
        let parameters = [
            "email_address": emailAddress,
            "password": password
        ]
        
        return parameters as [String : String]
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
    func parameterize() -> [String : String] {
        let parameters = [
            "email_address": emailAddress,
            "password": password,
            "company_name": companyName
        ]

        return parameters as [String : String]
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
    func parameterize() -> [String : String] {
        var parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email_address": emailAddress,
            ]
        if let password = password {
            parameters["password"] = password
        }
        
        return parameters as [String : String]
    }
}
public struct UpdateAccount {
    let companyName: String
    let subdomain: String
    let avatar: UIImage?
    
    public init(companyName: String, subdomain: String, avatar: UIImage? = nil) {
        self.companyName = companyName
        self.subdomain = subdomain
        self.avatar = avatar
    }
    func parameterize() -> [String : String] {
        let parameters = [
            "company_name": companyName,
            "subdomain": subdomain
        ]
        return parameters as [String : String]
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
        
        return parameters as [String : AnyObject]
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
            "name": name as AnyObject,
            "amount": amount as AnyObject,
            "interval": interval as AnyObject,
            "interval_count": intervalCount as AnyObject,
            "statement_descriptor": statementDescriptor as AnyObject,
            "trial_period_days": trialPeriodDays as AnyObject,
            "statement_description": statementDescription as AnyObject
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
            "first_name": firstName as AnyObject,
            "last_name": lastName as AnyObject,
            "email_address": emailAddress as AnyObject
        ]
        
        return parameters
    }
}
public struct AddPaymentCard {
    let userId: String
    let stripeToken: String
    
    public init(userId: String, stripeToken: String) {
        self.userId = userId
        self.stripeToken = stripeToken
    }
    func parameterize() -> [String: AnyObject] {
        let parameters: [String: AnyObject] = [
            "stripe_token": stripeToken as AnyObject
        ]
        
        return parameters
    }
}
public struct CreateCharge {
    let userId: String
    let amount: Double
    let description: String
    
    public init(userId: String, amount: Double, description: String) {
        self.userId = userId
        self.amount = amount
        self.description = description
    }
    func parameterize() -> [String: AnyObject] {
        let parameters: [String: AnyObject] = [
            "amount": amount as AnyObject,
            "description": description as AnyObject
        ]
        
        return parameters
    }
}
public struct UpgradeSubscription {
    let planId: String
    
    public init(planId: String) {
        self.planId = planId
    }
    func parameterize() -> [String: AnyObject] {
        let parameters: [String: AnyObject] = [
            "plan_id": planId as AnyObject
        ]
        
        return parameters
    }
}
open class ApiManager {
    fileprivate var kApiBaseUrl:String?
    open var apiBaseUrl: String {
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
    open var token: String?
    open static let sharedInstance = ApiManager()
    
    fileprivate init() {}
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        
        if let token = token {
            headers["x-access-token"] = token
        }
        
        return headers.count > 0 ? headers : nil;
    }
    open func authenticate(_ authenticateUser: AuthenticateUser, success: @escaping (_ userId: String, _ token: String) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = authenticateUser.parameterize()
        
        Alamofire.request(apiBaseUrl + "sessions", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let result = response.result.value  as? [String:AnyObject] {
                    if let userId = result["user_id"] as? String, let token = result["token"] as? String {
                        self.token = token
                        
                        success(userId, token)
                    } else {
                        failure(nil, nil)
                    }
                }  else {
                    failure(nil, nil)
                }
        }
    }
    open func validateUserName(_ emailAddress:String, success: @escaping (_ isValid: Bool) -> Void, failure: (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let urlString = "\(apiBaseUrl)users/\(emailAddress)"
        
        Alamofire.request(urlString, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .response { response in
                if response.response?.statusCode == 200 {
                    success(false)
                } else {
                    success(true)
                }
        }
    }
    open func createUser(_ createUser: CreateUser, success: @escaping (_ userId: String, _ token: String) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createUser.parameterize()
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                for (key, value) in params {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                 }
                if let avatar = createUser.avatar, let imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
            },
            to: apiBaseUrl + "users",
            encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON {
                        response in
                        
                        if let result = response.result.value  as? [String:AnyObject]  {
                            if let userId = result["user_id"] as? String, let token = result["token"] as? String {
                                self.token = token
                                
                                success(userId, token)
                            } else {
                                failure(nil, nil)
                            }
                        } else {
                            failure(nil, nil)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    open func updateUser(_ updateUser: UpdateUser, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = updateUser.parameterize()
        let urlString = "\(apiBaseUrl)users/\(updateUser.userId)"
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            if let avatar = updateUser.avatar, let imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
            }
        },
        to: urlString,
        method: .post,
        encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseObject { (response: DataResponse<User>) in
                        if let error = response.result.error {
                            var errorResponse: [String: AnyObject]? = [:]
                            
                            if let data = response.data {
                                do {
                                    errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                                } catch let error as NSError {
                                    failure(error, nil)
                                } catch let error {
                                    failure(error, nil)
                                }
                                failure(error, errorResponse)
                            } else {
                                failure(error, nil)
                            }
                        }
                        if let user = response.result.value {
                            success(user)
                        } else {
                            failure(nil, nil)
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    open func updateAccount(_ updateAccount: UpdateAccount, success: @escaping (_ response: Account) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = updateAccount.parameterize()
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            if let avatar = updateAccount.avatar, let imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
            }
        }, to: apiBaseUrl + "accounts",
           method: .put,
           headers: headers,
           encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseObject { (response: DataResponse<Account>) in
                        if let error = response.result.error {
                            var errorResponse: [String: AnyObject]? = [:]
                            
                            if let data = response.data {
                                do {
                                    errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                                } catch let error as NSError {
                                    failure(error, nil)
                                } catch let error {
                                    failure(error, nil)
                                }
                                failure(error, errorResponse)
                            } else {
                                failure(error, nil)
                            }
                        }
                        if let account = response.result.value {
                            success(account)
                        } else {
                            failure(nil, nil)
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    open func me(_ success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let user = response.result.value {
                    success(user)
                } else {
                    failure(nil, nil)
                }
                
        }
    }
    open func connectStripe(_ connectStripe: ConnectStripe, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = connectStripe.parameterize()
        
        Alamofire.request(apiBaseUrl + "users/\(connectStripe.userId)/connect_stripe", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }

    }
    open func importPlans(_ userId: String, plansList: [String], success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params: [String: AnyObject] = ["plans": plansList as AnyObject]
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/import_plans", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }
    }
    open func getPlans(_ page: Int = 1,success: @escaping (_ response: [Plan]) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "plans?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray(keyPath: "results") { (response: DataResponse<[Plan]>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        }
                        catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let plans = response.result.value {
                    success(plans)
                }
        }
        
    }
    open func getMembers(_ page: Int = 1, success: @escaping (_ response: [User]?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "members?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray(keyPath: "results") { (response: DataResponse<[User]>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        }
                        catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let users = response.result.value {
                    success(users)
                }
        }
        
    }
    open func getMembers(_ plan: Plan, _ page: Int = 1, success: @escaping (_ response: [User]?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "plans/\(plan.id!)/members?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[User]>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        }
                        catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let users = response.result.value {
                    success(users)
                }
        }
        
    }
    open func cancelSubscription(_ subscriptionId: String, success: @escaping ()  -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        
        Alamofire.request(apiBaseUrl + "subscriptions/\(subscriptionId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response {  response in
                if let error = response.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        }
                        catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                } else {
                    success()
                }
        }
    }
    open func upgradeSubscription(_ userId: String, _ subscriptionId: String, _ upgradeSubscription: UpgradeSubscription, success: @escaping (_ response: Subscription)  -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = upgradeSubscription.parameterize()
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/subscriptions/\(subscriptionId)/upgrade", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Subscription>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let subscription = response.result.value {
                    success(subscription)
                }
        }
    }
    open func createPlan(_ createPlan: CreatePlan, success: @escaping (_ response: Plan) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createPlan.parameterize()
        
        Alamofire.request(apiBaseUrl + "plans", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Plan>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let plan = response.result.value {
                    success(plan)
                }
        }
    }
    open func createMember(_ createMember: CreateMember, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createMember.parameterize()
        
        Alamofire.request(apiBaseUrl + "members", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }
    }
    open func addPaymentCard(_ addPaymentCard: AddPaymentCard, success: @escaping (_ response: PaymentCard) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = addPaymentCard.parameterize()
        
        Alamofire.request(apiBaseUrl + "/users/\(addPaymentCard.userId)/payment_cards", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<PaymentCard>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let paymentCard = response.result.value {
                    success(paymentCard)
                } else {
                    failure(nil, nil)
                }
        }
    }
    open func createCharge(_ createCharge: CreateCharge, success: @escaping (_ response: Charge) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createCharge.parameterize()
        
        Alamofire.request(apiBaseUrl + "/users/\(createCharge.userId)/charges", method: .post,  parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Charge>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let charge = response.result.value {
                    success(charge)
                } else {
                    failure(nil, nil)
                }
        }
    }
    public struct CreateMessage {
        let recipient: User
        let content: String
        
        public init(recipient: User, content:String) {
            self.recipient = recipient
            self.content = content
        }
        func parameterize() -> [String : String] {
            let parameters = [
                "content": content
            ]
            
            return parameters as [String : String]
        }
    }
    open func createMessage(_ createMessage: CreateMessage, success: @escaping (_ message: Message) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createMessage.parameterize()
        
        Alamofire.request(apiBaseUrl + "messages/\(createMessage.recipient.id!)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Message>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        } catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let message = response.result.value {
                    success(message)
                } else {
                    failure(nil, nil)
                }
        }
    }
    open func getMessages(_ recipient: User, _ page: Int = 1, success: @escaping (_ response: [Message]?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "messages/\(recipient.id!)?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[Message]>) in
                if let error = response.result.error {
                    var errorResponse: [String: AnyObject]? = [:]
                    
                    if let data = response.data {
                        do {
                            errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        } catch let error as NSError {
                            failure(error, nil)
                        }
                        catch let error {
                            failure(error, nil)
                        }
                        failure(error, errorResponse)
                    } else {
                        failure(error, nil)
                    }
                }
                if let messages = response.result.value {
                    success(messages)
                }
        }
        
    }
}
