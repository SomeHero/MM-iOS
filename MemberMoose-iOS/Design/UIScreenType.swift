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
        case narrow
        case wide
    }
    enum Height {
        case short
        case tall
    }
    
    static var width: Width {
        return UIScreen.main.bounds.width >= 375 ? .wide : .narrow
    }
    static var height: Height {
        return UIScreen.main.bounds.height >= 568 ? .tall : .short
    }
}
