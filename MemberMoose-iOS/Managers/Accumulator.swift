//
//  Accumulator.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 1/5/17.
//  Copyright © 2017 James Rhodes. All rights reserved.
//

import Foundation

public struct Accumulator : Accumulatable {
    static var bufferHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var currentPage: UInt
    var totalPages: UInt
    
    static func createAccumulator(currentPage: UInt, totalPages: UInt) -> Accumulator {
        return Accumulator(currentPage: currentPage, totalPages: totalPages)

    }
}
protocol Accumulatable {
    var currentPage: UInt {get set}
    var totalPages: UInt {get}
    
    var nextPage: UInt {get}
    
    func morePages() -> Bool
}

extension Accumulatable {
    var nextPage: UInt {
        return currentPage + 1
    }
    
    func morePages() -> Bool {
        if currentPage >= totalPages {
            return false
        }
        return true
    }
}
