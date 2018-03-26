//
//  Data+Convert.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

extension Data {
    
    var hexString: String {
        let nsdataStr = NSData.init(data: self)
        return nsdataStr.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
    }
}
