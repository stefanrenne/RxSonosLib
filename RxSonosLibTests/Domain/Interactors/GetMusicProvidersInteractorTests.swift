//
//  GetMusicProvidersInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/05/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetMusicProvidersInteractorTests: XCTestCase {
    
    let musicProvidersRepository: FakeMusicProvidersRepositoryImpl = FakeMusicProvidersRepositoryImpl()
    
    func testItCanGetTheMusicProviders() {
        XCTAssertEqual(musicProvidersRepository.getMusicProvidersCount.value, 0)
        let interactor = GetMusicProvidersInteractor(musicProvidersRepository: musicProvidersRepository)
        interactor.requestValues = GetMusicProvidersValues(room: firstRoom())
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        XCTAssertEqual(musicProvidersRepository.getMusicProvidersCount.value, 1)
    }
    
    func testItCantGetTheMusicProvidersWithoutVolumeValues() {
        let interactor = GetMusicProvidersInteractor(musicProvidersRepository: musicProvidersRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
