//
//  GetVolumeInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetVolumeInteractorTests: XCTestCase {
    
    let renderingControlRepository: RenderingControlRepository = FakeRenderingControlRepositoryImpl()
    
    func testItCanGetTheCurrentVolume() {
        let interactor = GetVolumeInteractor(renderingControlRepository: renderingControlRepository)
        let volume = try! interactor.get(values: GetVolumeValues(group: firstGroup()))
            .toBlocking(
            ).first()!
        
        XCTAssertEqual(volume, 70)
    }
    
    func testItCantGetTheCurrentVolumeWithoutAGroup() {
        let interactor = GetVolumeInteractor(renderingControlRepository: renderingControlRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
