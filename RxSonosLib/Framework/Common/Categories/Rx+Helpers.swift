//
//  Rx+Helpers.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func toVoid() -> Observable<Void> {
        return self.map { (_) -> Void in
            return ()
        }
    }
}
