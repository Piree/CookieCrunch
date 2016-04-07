//
//  Swap.swift
//  CookieCrunch
//
//  Created by Pierre Branéus on 2014-06-27.
//  Copyright (c) 2014 Pierre Branéus. All rights reserved.
//

class Swap: Printable, Hashable {
    var cookieA: Cookie
    var cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
    return "swap \(cookieA) with \(cookieB)"
    }
    
    var hashValue: Int {
    return cookieA.hashValue ^ cookieB.hashValue
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return  (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
            (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}
