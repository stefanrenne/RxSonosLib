//
//  SetVolumeInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class SetVolumeInteractorTests: XCTestCase {
    
    let renderingControlRepository: FakeRenderingControlRepositoryImpl = FakeRenderingControlRepositoryImpl()
    
    func testItCanSetTheCurrentVolume() {
        XCTAssertNil(renderingControlRepository.lastVolume)
        let interactor = SetVolumeInteractor(renderingControlRepository: renderingControlRepository)
        
        XCTAssertNoThrow(try interactor
            .get(values: SetVolumeValues(group: firstGroup(), volume: 40))
            .toBlocking()
            .toArray())
        
        XCTAssertEqual(renderingControlRepository.lastVolume, 40)
    }
    
    func testItCantSetTheCurrentVolumeWithoutVolumeValues() {
        let interactor = SetVolumeInteractor(renderingControlRepository: renderingControlRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
