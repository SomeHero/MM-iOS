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
    let firstName: String
    let lastName: String
    let avatar: UIImage?
    
    public init(emailAddress: String, password: String, firstName: String, lastName: String, avatar: UIImage? = nil) {
        self.emailAddress = emailAddress
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
    func parameterize() -> [String : AnyObject] {
        let parameters = [
            "email_address": emailAddress,
            "password": password,
            "first_name": firstName,
            "last_name": lastName
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
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON {
                        response in
                        
                        if let result = response.result.value {
                            if let userId = result["user_id"] as? String, token = result["token"] as? String {
                                self.token = token
                                
                                success(userId: userId, token: token)
                            } else {
                                failure(error: nil, errorDictionary: nil)
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    public func getPlans(success: (response: [Plan]?) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "plans", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .responseArray(keyPath: "data") { (response: Response<[Plan], NSError>) in
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
                if let markets = response.result.value {
                    success(response: markets)
                }
        }
        
    }
    public func getMembers(success: (response: [Member]?) -> Void, failure: (error: ErrorType?, errorDictionary: [String: AnyObject]?) -> Void) {
        Alamofire.request(.GET,  apiBaseUrl + "members", parameters: nil, encoding: .JSON, headers: headers)
            .validate()
            .responseArray(keyPath: "data") { (response: Response<[Member], NSError>) in
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
                if let markets = response.result.value {
                    success(response: markets)
                }
        }
        
    }
}
