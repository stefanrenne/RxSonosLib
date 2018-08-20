//
//  MockNetwork.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib

class MockNetwork: Network {

    override func createRequest() -> URLRequest? {
        return URLRequest(url: URL(string: "https://www.google.nl")!)
    }
    
    override func shouldPerformRequest(hasCache: Bool) -> Bool {
        return true
    }
}
