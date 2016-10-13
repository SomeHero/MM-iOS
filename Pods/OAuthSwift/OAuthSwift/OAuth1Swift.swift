//
//  OAuth1Swift.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/22/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import Foundation


public class OAuth1Swift: OAuthSwift {

    // If your oauth provider doesn't provide `oauth_verifier`
    // set value to true (default: false)
    public var allowMissingOauthVerifier: Bool = false

    var consumer_key: String
    var consumer_secret: String
    var request_token_url: String
    var authorize_url: String
    var access_token_url: String
    
    // MARK: init
    public init(consumerKey: String, consumerSecret: String, requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String){
        self.consumer_key = consumerKey
        self.consumer_secret = consumerSecret
        self.request_token_url = requestTokenUrl
        self.authorize_url = authorizeUrl
        self.access_token_url = accessTokenUrl
        super.init(consumerKey: consumerKey, consumerSecret: consumerSecret)
        self.client.credential.version = .OAuth1
    }

    public convenience init?(parameters: [String:String]){
        guard let consumerKey = parameters["consumerKey"], consumerSecret = parameters["consumerSecret"],
            requestTokenUrl = parameters["requestTokenUrl"], authorizeUrl = parameters["authorizeUrl"], accessTokenUrl = parameters["accessTokenUrl"] else {
            return nil
        }
        self.init(consumerKey:consumerKey, consumerSecret: consumerSecret,
          requestTokenUrl: requestTokenUrl,
          authorizeUrl: authorizeUrl,
          accessTokenUrl: accessTokenUrl)
    }

    public var parameters: [String: String] {
        return [
            "consumerKey": consumer_key,
            "consumerSecret": consumer_secret,
            "requestTokenUrl": request_token_url,
            "authorizeUrl": authorize_url,
            "accessTokenUrl": access_token_url
        ]
    }

    // MARK: functions
    // 0. Start
    public func authorizeWithCallbackURL(callbackURL: NSURL, success: TokenSuccessHandler, failure: FailureHandler?) {
        self.postOAuthRequestTokenWithCallbackURL(callbackURL, success: { [unowned self]
            credential, response, _ in

            self.observeCallback { [weak self] url in
                guard let this = self else { OAuthSwift.retainError(failure); return }
                var responseParameters = [String: String]()
                if let query = url.query {
                    responseParameters += query.parametersFromQueryString()
                }
                if let fragment = url.fragment where !fragment.isEmpty {
                    responseParameters += fragment.parametersFromQueryString()
                }
                if let token = responseParameters["token"] {
                    responseParameters["oauth_token"] = token
                }
                if let token = responseParameters["oauth_token"] where (this.allowMissingOauthVerifier || responseParameters["oauth_verifier"] != nil) {
                    this.client.credential.oauth_token = token.safeStringByRemovingPercentEncoding
                    if let oauth_verifier = responseParameters["oauth_verifier"] {
                        this.client.credential.oauth_verifier = oauth_verifier.safeStringByRemovingPercentEncoding
                    }
                    this.postOAuthAccessTokenWithRequestToken(success, failure: failure)
                } else {
                    let message = this.allowMissingOauthVerifier ? "Oauth problem. oauth_token not returned" : "Oauth problem. oauth_token or oauth_verifier not returned"
                    failure?(error: NSError(code: .MissingTokenOrVerifier, message: message))
                    return
                }
            }
            // 2. Authorize
            let urlString = self.authorize_url + (self.authorize_url.has("?") ? "&" : "?")
            if let token = credential.oauth_token.urlQueryEncoded, queryURL = NSURL(string: urlString + "oauth_token=\(token)") {
                self.authorize_url_handler.handle(queryURL)
            }
            else {
                let message = NSLocalizedString("Failed to create URL", comment: "\(urlString) not convertible to URL, please encode.")
                failure?(error: NSError(code: .EncodingError, message: message))
            }
        }, failure: failure)
    }

    // 1. Request token
    func postOAuthRequestTokenWithCallbackURL(callbackURL: NSURL, success: TokenSuccessHandler, failure: FailureHandler?) {
        var parameters =  Dictionary<String, AnyObject>()
        if let callbackURLString: String = callbackURL.absoluteString {
            parameters["oauth_callback"] = callbackURLString
        }
        self.client.post(self.request_token_url, parameters: parameters, success: {
            [weak self] data, response in
            guard let this = self else { OAuthSwift.retainError(failure); return }
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding) as String!
            let parameters = responseString.parametersFromQueryString()
            if let oauthToken=parameters["oauth_token"] {
                this.client.credential.oauth_token = oauthToken.safeStringByRemovingPercentEncoding
            }
            if let oauthTokenSecret=parameters["oauth_token_secret"] {
                this.client.credential.oauth_token_secret = oauthTokenSecret.safeStringByRemovingPercentEncoding
            }
            success(credential: this.client.credential, response: response, parameters: parameters)
        }, failure: failure)
    }

    // 3. Get Access token
    func postOAuthAccessTokenWithRequestToken(success: TokenSuccessHandler, failure: FailureHandler?) {
        var parameters = Dictionary<String, AnyObject>()
        parameters["oauth_token"] = self.client.credential.oauth_token
        parameters["oauth_verifier"] = self.client.credential.oauth_verifier
        self.client.post(self.access_token_url, parameters: parameters, success: {
            [weak self] data, response in
            guard let this = self else { OAuthSwift.retainError(failure); return }
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding) as String!
            let parameters = responseString.parametersFromQueryString()
            if let oauthToken=parameters["oauth_token"] {
                this.client.credential.oauth_token = oauthToken.safeStringByRemovingPercentEncoding
            }
            if let oauthTokenSecret=parameters["oauth_token_secret"] {
                this.client.credential.oauth_token_secret = oauthTokenSecret.safeStringByRemovingPercentEncoding
            }
            success(credential: this.client.credential, response: response, parameters: parameters)
        }, failure: failure)
    }

}