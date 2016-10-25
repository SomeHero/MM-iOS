//
//  Constants.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

#if DEBUG
let kApiBaseUrl = "http://localhost:8080/api/"
//let kApiBaseUrl = "http://192.168.1.135:8080/api/"
//let kApiBaseUrl = "https://membermoose-node.herokuapp.com/api/"
let kOnePX: CGFloat = 1.0 / UIScreen.mainScreen().scale
let kStripeConnectClientId = "ca_7DVAPFFiNfWjJn8L08FZ1Sa4unt0jxfF"
let kStripeSecretKey = "sk_test_UknG37aSTprP5EfEmqSWNGvn"
let kStripePublishableKey = "pk_test_5Km0uUASqaRvRu1JTx8Iiefx"
let kStripeOAuthRedirectUrl = "http://membermoose-node.herokuapp.com/oauth-callback/stripe"
let kGoogleTrackingId = "UA-78467459-3"
let kCognitoPoolID = "us-east-1:0f789e2a-95db-450f-8698-322a99c2cfe1"
let kS3BucketName = "ishopaway-staging"
let kS3ImageBaseUrl = "https://s3.amazonaws.com/ishopaway-staging/"
#else
let kApiBaseUrl = "https://membermoose-node.herokuapp.com/api/"
let kOnePX: CGFloat = 1.0 / UIScreen.mainScreen().scale
let kStripeConnectClientId = "ca_7DVAUfx8xLJTPOnRY3zRS9g2MEZDzFm2"
let kStripeSecretKey = "sk_live_U361w1bbwEZNe7p9vOyrl5TC"
let kStripePublishableKey = "pk_live_aivTnifXScRTBnrEiWv4ufU2"
let kStripeOAuthRedirectUrl = "https://membermoose-node.herokuapp.com/oauth-callback/stripe"
let kGoogleTrackingId = "UA-78467459-3"
let kCognitoPoolID = "us-east-1:0f789e2a-95db-450f-8698-322a99c2cfe1"
let kS3BucketName = "ishopaway-prod"
let kS3ImageBaseUrl = "https://s3.amazonaws.com/ishopaway-prod/"
#endif