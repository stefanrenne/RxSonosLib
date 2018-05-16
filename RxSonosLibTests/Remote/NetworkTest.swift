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
    
    override func setUp() {
        CacheManager.shared.deleteAll()
        stub(everything, http(404))
    }
    
    func testItCanProcess404Errors() {
        XCTAssertThrowsError(try MockNetwork().executeRequest().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibUnknownUrlError().localizedDescription)
        }
    }
    
    func testCreateRequestNeedsToBeOverwritten() {
        XCTAssertThrowsError(try Network().executeRequest().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibNoDataError().localizedDescription)
        }
    }
    
    func testSoapCallsCantUseExetureRequest() {
        XCTAssertThrowsError(try SoapNetwork(room: firstRoom(), action: SoapAction.getVolume).executeRequest().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
    func testCreateRequestNeedsToBeOverwrittenUnlessIfThereIsCachedData() {
        let key = "randomKey"
        let data = "random".data(using: .utf8)!
        CacheManager.shared.set(data, for: key)
        
        let resultData = try? Network(cacheKey: key)
            .executeRequest()
            .toBlocking()
            .single()
        XCTAssertEqual(resultData, data)
    }
    
    func testItCanProcessHTTPErrors() {
        let error = NSError(domain: "randomdomain", code: 9001, userInfo: ["message": "it's over 9000!"])
        stub(everything, failure(error))
            
        XCTAssertThrowsError(try MockNetwork().executeRequest().toBlocking().toArray()) { resultError in
            XCTAssertEqual(resultError.localizedDescription, error.localizedDescription)
        }
    }
    
    func testItCanProcessEmptyResponses() {
        stub(everything, http(200))
        
        XCTAssertThrowsError(try MockNetwork().executeRequest().toBlocking().toArray()) { resultError in
            XCTAssertEqual(resultError.localizedDescription, NSError.sonosLibInvalidDataError().localizedDescription)
        }
    }
    
    func testResponsesAreReturnedOnceWhenThereIsNoCache() {
        
        let key = "randomKey"
        let httpData = "httpData".data(using: .utf8)!
        
        stub(everything, http(download: .content(httpData)))
        
        let resultData = try? MockNetwork(cacheKey: key)
            .executeRequest()
            .toBlocking()
            .toArray()
        
        XCTAssertEqual(resultData!, [httpData])
    }
    
    func testResponsesAreReturnedMultipleTimesWhenTheyAreDifferentFromCache() {
        
        let key = "randomKey"
        let cacheData = "cacheData".data(using: .utf8)!
        CacheManager.shared.set(cacheData, for: key)
        
        let httpData = "httpData".data(using: .utf8)!
        
        stub(everything, http(download: .content(httpData)))
        
        let resultData = try? MockNetwork(cacheKey: key)
            .executeRequest()
            .toBlocking()
            .toArray()
        
        XCTAssertEqual(resultData!, [cacheData, httpData])
    }
    
    func testResponsesAreReturnedOnceWhenTheyAreDifferentFromCache() {
        
        let key = "randomKey"
        let data = "random".data(using: .utf8)!
        CacheManager.shared.set(data, for: key)
        
        stub(everything, http(download: .content(data)))
        
        let resultData = try? MockNetwork(cacheKey: key)
            .executeRequest()
            .toBlocking()
            .toArray()
        
        XCTAssertEqual(resultData!, [data])
    }
    
}
