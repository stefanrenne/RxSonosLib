//
//  GetMusicServicesInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/05/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetMusicServicesInteractorTests: XCTestCase {
    
    let musicServicesRepository: FakeMusicServicesRepositoryImpl = FakeMusicServicesRepositoryImpl()
    
    func testItCanGetTheMusicServices() {
        XCTAssertEqual(musicServicesRepository.getMusicServicesCount, 0)
        let interactor = GetMusicServicesInteractor(musicServicesRepository: musicServicesRepository)
        
        XCTAssertNoThrow(try interactor
            .get(values: GetMusicServicesValues(room: firstRoom()))
            .toBlocking()
            .toArray())
        XCTAssertEqual(musicServicesRepository.getMusicServicesCount, 1)
    }
    
    func testItCantGetTheMusicServicesWithoutVolumeValues() {
        let interactor = GetMusicServicesInteractor(musicServicesRepository: musicServicesRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
