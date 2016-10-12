//
//  UIScreenType.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

struct UIScreenSizeType {
    enum Width {
        case Narrow
        case Wide
    }
    enum Height {
        case Short
        case Tall
    }
    
    static var width: Width {
        return UIScreen.mainScreen().bounds.width >= 375 ? .Wide : .Narrow
    }
    static var height: Height {
        return UIScreen.mainScreen().bounds.height >= 568 ? .Tall : .Short
    }
}
