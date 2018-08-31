//
//  NetworkTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import Mockingjay
@testable import RxSonosLib

class NetworkTest: XCTestCase {
    
    private let request = URLRequest(url: URL(string: "https://www.google.com")!)
    
    func testItCanProcess404Errors() {
        stub(everything, http(404))
        XCTAssertThrowsError(try MockNetwork().perform(request: request).toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibUnknownUrlError().localizedDescription)
        }
    }
    
    func testItCanProcessEmptyResponses() {
        stub(everything, http(200))
        
        XCTAssertThrowsError(try MockNetwork().perform(request: request).toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidDataError().localizedDescription)
        }
    }
    
    func testItCanProcessHTTPErrors() {
        let stubbedError = NSError(domain: "randomdomain", code: 9001, userInfo: ["message": "it's over 9000!"])
        stub(everything, failure(stubbedError))
        
        XCTAssertThrowsError(try MockNetwork().perform(request: request).toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, stubbedError.localizedDescription)
        }
    }
    
    func testItCanProcessResponseData() {
        let stubbedData = "random".data(using: .utf8)!
        
        stub(everything, http(download: .content(stubbedData)))
        
        let result = try? MockNetwork()
            .perform(request: request)
            .toBlocking()
            .single()
        
        XCTAssertEqual(result, stubbedData)
    }
    
}
