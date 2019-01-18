//
//  String+Empty.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

extension String {
    func nilIfEmpty() -> String? {
        if isEmpty {
            return nil
        }
        return self
    }
}
