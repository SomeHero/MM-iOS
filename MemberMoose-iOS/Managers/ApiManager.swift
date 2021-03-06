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
public struct RefreshToken {
    let token: String
    
    public init(token: String) {
        self.token = token
    }
    func parameterize() -> [String : String] {
        let parameters = [
            "refresh_token": token
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
    let user: User
    let stripeParams: [String: AnyObject]
    
    public init(user: User, stripeParams: [String: AnyObject]) {
        self.user = user
        self.stripeParams = stripeParams
    }
    func parameterize() -> [String: AnyObject] {
        let parameters = [
            "stripe_connect": stripeParams
        ]
        
        return parameters as [String : AnyObject]
    }
}
public struct RegisterDevice {
    let user: User
    let token: String
    let deviceIdentifier: String
    let deviceType: String
    
    public init(user: User, token: String, deviceIdentifier: String, deviceType: String) {
        self.user = user
        self.token = token
        self.deviceIdentifier = deviceIdentifier
        self.deviceType = deviceType
    }
    func parameterize() -> [String : String] {
        let parameters = [
            "device_token": token,
            "device_identifier": deviceIdentifier,
            "device_type": deviceType
        ]
        return parameters as [String : String]
    }
}
public struct CreatePlan {
    let plan: Plan
    let avatar: UIImage?
    
    public init(plan: Plan, avatar: UIImage?) {
        self.plan = plan
        self.avatar = avatar
    }
    func parameterize() -> [String: String] {
        var parameters: [String: String] = [:]
        
        if let name = plan.name {
            parameters["name"] = name
        }
        if let description = plan.description {
            parameters["description"] = description
        }
        //"features": plan.features as AnyObject,
        if let oneTimeAmount = plan.oneTimeAmount {
            parameters["one_time_amount"] = String(oneTimeAmount)
        }
        if let amount = plan.amount {
            parameters["amount"] = String(amount)
        }
        if let interval = plan.interval {
            parameters["interval"] = interval.description
        }
        parameters["interval_count"] = String(plan.intervalCount)
        if let statementDescriptor = plan.statementDescriptor {
            parameters["statement_descriptor"] = statementDescriptor
        }
        parameters["trial_period_days"] = String(plan.trialPeriodDays)
        if let statementDescription = plan.statementDescription {
            parameters["statement_description"] = statementDescription
        }
        if let termsOfService = plan.termsOfService {
            parameters["terms_of_service"] = termsOfService
        }

        
        return parameters
    }
}
public struct UpdatePlan {
    let plan: Plan
    let avatar: UIImage?
    
    public init(plan: Plan, avatar: UIImage?) {
        self.plan = plan
        self.avatar = avatar
    }
    func parameterize() -> [String: String] {
        var parameters: [String: String] = [:]
        
        if let planId = plan.id {
            parameters["reference_id"] = planId
        }
        if let name = plan.name {
            parameters["name"] = name
        }
        if let description = plan.description {
            parameters["description"] = description
        }
        //"features": plan.features as AnyObject,
        if let oneTimeAmount = plan.oneTimeAmount {
            parameters["one_time_amount"] = String(oneTimeAmount)
        }
        if let amount = plan.amount {
            parameters["amount"] = String(amount)
        }
        if let interval = plan.interval {
            parameters["interval"] = interval.description
        }
        parameters["interval_count"] = String(plan.intervalCount)
        if let statementDescriptor = plan.statementDescriptor {
            parameters["statement_descriptor"] = statementDescriptor
        }
        parameters["trial_period_days"] = String(plan.trialPeriodDays)
        if let statementDescription = plan.statementDescription {
            parameters["statement_description"] = statementDescription
        }
        if let termsOfService = plan.termsOfService {
            parameters["terms_of_service"] = termsOfService
        }
        
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
    let user: User
    let stripeToken: String
    
    public init(user: User, stripeToken: String) {
        self.user = user
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
    let user: User
    let amount: Double
    let description: String
    
    public init(user: User, amount: Double, description: String) {
        self.user = user
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
    var refreshToken: String?
    
    open static let sharedInstance = ApiManager()
    
    fileprivate init() {}
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        
        if let token = token {
            headers["x-access-token"] = token
        }
        
        return headers.count > 0 ? headers : nil;
    }
    func handleRefreshToken(_ refreshToken: String, _ success: @escaping () -> Void, _ failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        self.refresh(RefreshToken(token: refreshToken), success: { (userId, token, refreshToken) in
            self.token = token
            self.refreshToken = refreshToken
            
            SessionManager.sharedInstance.setRefreshToken(refreshToken)
            
            success()
        }, failure: failure)
    }
    func handleError(_ error: Error?, _ data: Data?, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        var errorResponse: [String: AnyObject]? = [:]
        
        if let data = data {
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
    open func authenticate(_ authenticateUser: AuthenticateUser, success: @escaping (_ userId: String, _ token: String, _ refreshToken: String) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = authenticateUser.parameterize()
        
        Alamofire.request(apiBaseUrl + "sessions", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let error = response.result.error {
                    self.handleError(error, response.data, failure: failure);
                }
                if let result = response.result.value  as? [String:AnyObject] {
                    if let userId = result["user_id"] as? String, let token = result["token"] as? String, let refreshToken = result["refresh_token"] as? String {
                        self.token = token
                        self.refreshToken = refreshToken
                        
                        success(userId, token, refreshToken)
                    } else {
                        failure(nil, nil)
                    }
                }  else {
                    failure(nil, nil)
                }
        }
    }
    open func refresh(_ refreshToken: RefreshToken, success: @escaping (_ userId: String, _ token: String, _ refreshToken: String) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = refreshToken.parameterize()
        
        Alamofire.request(apiBaseUrl + "sessions/verify", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let error = response.result.error {
                    self.handleError(error, response.data, failure: failure);
                }
                if let result = response.result.value  as? [String:AnyObject] {
                    if let userId = result["user_id"] as? String, let token = result["token"] as? String, let refreshToken = result["refresh_token"] as? String {
                        success(userId, token, refreshToken)
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
            headers: headers,
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
        method: .put,
        headers: headers,
        encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseObject { (response: DataResponse<User>) in
                        if let error = response.result.error {
                            if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                                self.handleRefreshToken(refreshToken, {
                                    self.updateUser(updateUser, success: success, failure: failure)
                                }, { (error, errorDictionary) in
                                    failure(error, errorDictionary)
                                })
                            } else {
                                self.handleError(error, response.data, failure: failure);
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
                            if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                                self.handleRefreshToken(refreshToken, {
                                    self.updateAccount(updateAccount, success: success, failure: failure)
                                }, { (error, errorDictionary) in
                                    failure(error, errorDictionary)
                                })
                            } else {
                                self.handleError(error, response.data, failure: failure);
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
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.me(success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                } else {
                    if let user = response.result.value {
                        success(user)
                    } else {
                        failure(nil, nil)
                    }
                }
                
        }
    }
    open func connectStripe(_ connectStripe: ConnectStripe, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let userId = connectStripe.user.id else {
            return
        }
        let params = connectStripe.parameterize()
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/connect_stripe", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.connectStripe(connectStripe, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
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
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.importPlans(userId, plansList: plansList, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }
    }
    open func registerDevice(_ registerDevice: RegisterDevice, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let userId = registerDevice.user.id else {
            return
        }
        let params = registerDevice.parameterize()
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/devices", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.registerDevice(registerDevice, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }
        
    }
    open func getActivities(success: @escaping (_ response: [ActivityGroup]) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "activities?page=1", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[ActivityGroup]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getActivities(success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let activities = response.result.value {
                    success(activities)
                }
        }
        
    }
    open func getActivities(_ plan: Plan,success: @escaping (_ response: [ActivityGroup]) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let planId = plan.id else {
            return
        }
        Alamofire.request(apiBaseUrl + "plans/\(planId)/activities?page=1", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[ActivityGroup]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getActivities(plan, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let activities = response.result.value {
                    success(activities)
                }
        }
        
    }
    open func getActivities(_ user: User, success: @escaping (_ response: [ActivityGroup]) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let userId = user.id else {
            return
        }

        Alamofire.request(apiBaseUrl + "users/\(userId)/activities", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[ActivityGroup]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getActivities(user, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let activities = response.result.value {
                    success(activities)
                }
        }
        
    }
    open func getPlans(_ page: Int = 1, success: @escaping (_ plans: [Plan], _ accumulator: Accumulator?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "plans?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray(keyPath: "results") { (response: DataResponse<[Plan]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getPlans(page, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                } else {
                    if let plans = response.result.value {
                        if let data = response.data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                    if let maxPages = json["max_pages"]?.integerValue {
                                        let accumulator = Accumulator.createAccumulator(currentPage: UInt(page), totalPages: UInt(maxPages))
                                        
                                        success(plans, accumulator)
                                    } else {
                                        success(plans, nil)
                                    }
                                }
                            } catch let error {
                                print(error)
                                success(plans, nil)
                            }
                        }
                        
                    } else {
                        failure(nil, nil)
                    }
                }
        }
        
    }
    open func getMembers(_ page: Int = 1, success: @escaping (_ users: [User], _ accumulator: Accumulator?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "members?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray(keyPath: "results") { (response: DataResponse<[User]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getMembers(page, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let users = response.result.value {
                    if let data = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                if let maxPages = json["max_pages"]?.integerValue {
                                    let accumulator = Accumulator.createAccumulator(currentPage: UInt(page), totalPages: UInt(maxPages))
                                    
                                    success(users, accumulator)
                                } else {
                                    success(users, nil)
                                }
                            }
                        } catch let error {
                            print(error)
                            success(users, nil)
                        }
                    }
                    
                }
        }
        
    }
    open func getMembers(_ plan: Plan, _ page: Int = 1, success: @escaping (_ users: [User], _ accumulator: Accumulator?) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(apiBaseUrl + "plans/\(plan.id!)/members?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray(keyPath: "results") { (response: DataResponse<[User]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getMembers(plan, page, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let users = response.result.value {
                    if let data = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                if let maxPages = json["max_pages"]?.integerValue {
                                    let accumulator = Accumulator.createAccumulator(currentPage: UInt(page), totalPages: UInt(maxPages))
                                    
                                    success(users, accumulator)
                                } else {
                                    success(users, nil)
                                }
                            }
                        } catch let error {
                            print(error)
                            success(users, nil)
                        }
                    }
                    
                }
        }
        
    }
    open func cancelSubscription(_ userId: String,_ subscriptionId: String, success: @escaping ()  -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/subscriptions/\(subscriptionId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response {  response in
                if let error = response.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.cancelSubscription(userId, subscriptionId, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
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
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.upgradeSubscription(userId, subscriptionId, upgradeSubscription, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let subscription = response.result.value {
                    success(subscription)
                }
        }
    }
    open func createPlan(_ createPlan: CreatePlan, success: @escaping (_ response: Plan) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createPlan.parameterize()
        
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                for (key, value) in params {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if let avatar = createPlan.avatar, let imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
        },
            to: apiBaseUrl + "plans",
            method: .post,
            headers: headers,
            encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseObject { (response: DataResponse<Plan>) in
                            if let error = response.result.error {
                                if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                                    self.handleRefreshToken(refreshToken, {
                                        self.createPlan(createPlan, success: success, failure: failure)
                                    }, { (error, errorDictionary) in
                                        failure(error, errorDictionary)
                                    })
                                } else {
                                    self.handleError(error, response.data, failure: failure);
                                }
                            }
                            if let plan = response.result.value {
                                success(plan)
                            } else {
                                failure(nil, nil)
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    func updatePlan(_ updatePlan: UpdatePlan, success: @escaping (_ response: Plan) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = updatePlan.parameterize()
        
        guard let planId = updatePlan.plan.id else {
            return
        }
        
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                for (key, value) in params {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if let avatar = updatePlan.avatar, let imageData = UIImageJPEGRepresentation(avatar, 1.0) {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
        },
            to: apiBaseUrl + "plans/\(planId)",
            method: .put,
            headers: headers,
            encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseObject { (response: DataResponse<Plan>) in
                            if let error = response.result.error {
                                if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                                    self.handleRefreshToken(refreshToken, {
                                        self.updatePlan(updatePlan, success: success, failure: failure)
                                    }, { (error, errorDictionary) in
                                        failure(error, errorDictionary)
                                    })
                                } else {
                                    self.handleError(error, response.data, failure: failure);
                                }
                            }
                            if let plan = response.result.value {
                                success(plan)
                            } else {
                                failure(nil, nil)
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    open func deletePlan(_ planId: String, success: @escaping ()  -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        
        Alamofire.request(apiBaseUrl + "plans/\(planId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response {  response in
                if let error = response.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.deletePlan(planId, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                } else {
                    success()
                }
        }
    }
    open func createMember(_ createMember: CreateMember, success: @escaping (_ response: User) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createMember.parameterize()
        
        Alamofire.request(apiBaseUrl + "members", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<User>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.createMember(createMember, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let user = response.result.value {
                    success(user)
                }
        }
    }
    open func addPaymentCard(_ addPaymentCard: AddPaymentCard, success: @escaping (_ response: PaymentCard) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let userId = addPaymentCard.user.id else {
            return
        }
        let params = addPaymentCard.parameterize()
        
        Alamofire.request(apiBaseUrl + "/users/\(userId)/payment_cards", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<PaymentCard>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.addPaymentCard(addPaymentCard, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
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
        guard let userId = createCharge.user.id else {
            return
        }
        let params = createCharge.parameterize()
        
        Alamofire.request(apiBaseUrl + "/users/\(userId)/charges", method: .post,  parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Charge>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.createCharge(createCharge, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let charge = response.result.value {
                    success(charge)
                } else {
                    failure(nil, nil)
                }
        }
    }
    open func getCharges(_ user: User, success: @escaping (_ response: [Charge]) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        guard let userId = user.id else {
            return
        }
        
        Alamofire.request(apiBaseUrl + "users/\(userId)/charges", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseArray { (response: DataResponse<[Charge]>) in
                if let error = response.result.error {
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getCharges(user, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let charges = response.result.value {
                    success(charges)
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
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.createMessage(createMessage, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
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
                    if let httpResponse = response.response, let refreshToken = self.refreshToken, httpResponse.statusCode == 401 {
                        self.handleRefreshToken(refreshToken, {
                            self.getMessages(recipient, page, success: success, failure: failure)
                        }, { (error, errorDictionary) in
                            failure(error, errorDictionary)
                        })
                    } else {
                        self.handleError(error, response.data, failure: failure);
                    }
                }
                if let messages = response.result.value {
                    success(messages)
                }
        }
        
    }
}
