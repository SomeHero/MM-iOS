//
//  MessagesApiManager.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/14/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper


open class MessagesApiManager: ApiManager {
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
    open func createMessasge(_ createMessage: CreateMessage, success: @escaping (_ message: Message) -> Void, failure: @escaping (_ error: Error?, _ errorDictionary: [String: AnyObject]?) -> Void) {
        let params = createMessage.parameterize()
        
        Alamofire.request(apiBaseUrl + "messages/\(createMessage.recipient.id)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
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
                if let message = response.result.value as? Message {
                    success(message)
                } else {
                    failure(nil, nil)
                }
        }
    }
}
