//
//  Constants.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

#if DEBUG
let kApiBaseUrl = "http://172.20.10.3:8080/api/"
//let kApiBaseUrl = "https://membermoose-node.herokuapp.com/api/"
let kOnePX: CGFloat = 1.0 / UIScreen.mainScreen().scale
let kStripePublishableKey = "pk_test_biSyfSYHVZjhj0lVfqep9HOA"
let kGoogleTrackingId = "UA-78467459-3"
let kCognitoPoolID = "us-east-1:0f789e2a-95db-450f-8698-322a99c2cfe1"
let kS3BucketName = "ishopaway-staging"
let kS3ImageBaseUrl = "https://s3.amazonaws.com/ishopaway-staging/"
#else
let kApiBaseUrl = "https://membermoose-node.herokuapp.com/api/"
let kOnePX: CGFloat = 1.0 / UIScreen.mainScreen().scale
let kStripePublishableKey = "pk_test_biSyfSYHVZjhj0lVfqep9HOA"
let kGoogleTrackingId = "UA-78467459-3"
let kCognitoPoolID = "us-east-1:0f789e2a-95db-450f-8698-322a99c2cfe1"
let kS3BucketName = "ishopaway-prod"
let kS3ImageBaseUrl = "https://s3.amazonaws.com/ishopaway-prod/"
#endif