//
//  GetTrackImageInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetTrackImageInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
    
    func testItCanGetTheCurrentImage() {
        let interactor = GetTrackImageInteractor(transportRepository: transportRepository)
        let imageData = try! interactor.get(values: GetTrackImageValues(track: firstTrack()))
            .toBlocking()
            .first()!
        
        let expectedData = UIImagePNGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        XCTAssertEqual(imageData, expectedData)
    }
    
    func testItCantGetTheCurrentImageWithoutATrack() {
        let interactor = GetTrackImageInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
