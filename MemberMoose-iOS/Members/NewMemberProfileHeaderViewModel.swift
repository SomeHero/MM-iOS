//
//  NewMemberProfileHeaderViewModel.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/15/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//


import UIKit

class NewMemberProfileHeaderViewModel {
    var cellID: String = "NewMemberProfileHeaderCellIdentifier"

    let avatar: String
    var avatarImageUrl: String?
    let name: String?
    let memberSince: String

    init(user: User) {
        self.avatar = "Avatar-Calf"
        if let avatar = user.avatar, let avatarImageUrl = avatar["large"] {
            self.avatarImageUrl = avatarImageUrl
        }
        if let firstName = user.firstName, let lastName = user.lastName {
            self.name = "\(firstName) \(lastName)"
        } else {
            self.name = user.emailAddress
        }
        self.memberSince = "New Member"
    }
}

