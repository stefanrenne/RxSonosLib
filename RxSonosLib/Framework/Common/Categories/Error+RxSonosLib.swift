//
//  Error+RxSonosLib.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

fileprivate let sonosLibDomain = "RxSonosLib"

extension NSError {
    
    static func sonosLibNoDataError() -> Error {
        return NSError(domain: sonosLibDomain, code: 40001, userInfo: nil)
    }
    
    static func sonosLibInvalidDataError() -> Error {
        return NSError(domain: sonosLibDomain, code: 40002, userInfo: nil)
    }
    
    static func sonosLibUnknownUrlError() -> Error {
        return NSError(domain: sonosLibDomain, code: 40003, userInfo: nil)
    }
    
}
