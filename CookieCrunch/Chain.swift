//
//  Chain.swift
//  CookieCrunch
//
//  Created by Pierre Branéus on 2014-06-27.
//  Copyright (c) 2014 Pierre Branéus. All rights reserved.
//

class Chain: Hashable, Printable {
    var cookies = Array <Cookie>() // private
    
    enum ChainType: Printable {
        case Horizontal
        case Vertical
        
        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addCookie(cookie: Cookie) {
        cookies.append(cookie)
    }
    
    func firstCookie() -> Cookie {
        return cookies[0]
    }
    
    func lastCookie() -> Cookie {
        return cookies[cookies.count - 1]
    }
    
    var length: Int {
        return cookies.count
    }
    
    var description: String {
        return "type: \(chainType) cookies: \(cookies)"
    }
    
    var hashValue: Int {
    return reduce(cookies, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    var score: Int = 0
    
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.cookies == rhs.cookies
}
