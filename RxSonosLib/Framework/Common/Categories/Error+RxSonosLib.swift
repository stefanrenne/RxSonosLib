//
//  Error+RxSonosLib.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public extension NSError {
    
    public static var sonosLibDomain: String { return "RxSonosLib" }
    
    public static var sonosLibNoDataErrorCode: Int { return 4001 }
    static func sonosLibNoDataError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibNoDataErrorCode, userInfo: nil)
    }
    
    public static var sonosLibInvalidDataErrorCode: Int { return 4002 }
    static func sonosLibInvalidDataError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibInvalidDataErrorCode, userInfo: nil)
    }
    
    public static var sonosLibUnknownUrlErrorCode: Int { return 4003 }
    static func sonosLibUnknownUrlError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibUnknownUrlErrorCode, userInfo: nil)
    }
    
    public static var sonosLibInvalidImplementationErrorCode: Int { return 4004 }
    static func sonosLibInvalidImplementationError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibInvalidImplementationErrorCode, userInfo: nil)
    }
    
    public static var sonosLibNoGroupErrorCode: Int { return 4005 }
    static func sonosLibNoGroupError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibNoGroupErrorCode, userInfo: nil)
    }
    
    public static var sonosLibNoTrackErrorCode: Int { return 4006 }
    static func sonosLibNoTrackError() -> Error {
        return NSError(domain: sonosLibDomain, code: sonosLibNoTrackErrorCode, userInfo: nil)
    }
    
}
