//
//  MessageViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/17/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

class MessageViewModel {

    let avatar: String
    var avatarUrl: String?
    let authorName: String?
    let content: String
    let messageSent: String
    let dateFormatter = DateFormatters.timeStampDateFormatter
    

    init(message: Message) {
        self.avatar = "Avatar-Calf"
        if let avatarImageUrl = message.sender.gravatarUrl {
            self.avatarUrl = avatarImageUrl
        } else {
            self.avatarUrl = nil
        }
        if let account =  message.sender.account {
            authorName = account.companyName
        } else {
            if let firstName = message.sender.firstName, let lastName = message.sender.lastName {
                authorName = "\(firstName) \(lastName)"
            } else {
                authorName = message.sender.emailAddress
            }
        }
        self.content = message.content
        self.messageSent = dateFormatter.string(from: message.createdAt)
    }
}
