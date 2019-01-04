//
//  DeviceDescription.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import AEXML

class DeviceDescription: Codable {
    
    let name: String
    let modalNumber: String
    let modalName: String
    let modalIcon: String
    let serialNumber: String
    let softwareVersion: String
    let hardwareVersion: String
    
    init (name: String, modalNumber: String, modalName: String, modalIcon: String, serialNumber: String, softwareVersion: String, hardwareVersion: String) {
        self.name = name
        self.modalNumber = modalNumber
        self.modalName = modalName
        self.modalIcon = modalIcon
        self.serialNumber = serialNumber
        self.softwareVersion = softwareVersion
        self.hardwareVersion = hardwareVersion
    }
}

extension DeviceDescription {
    class func map(_ xml: AEXMLDocument) -> DeviceDescription? {
        guard let name = xml["root"]["device"]["roomName"].value,
            let modalNumber = xml["root"]["device"]["modelNumber"].value,
            let modalName = xml["root"]["device"]["modelName"].value,
            let modalIcon = xml["root"]["device"]["iconList"]["icon"]["url"].value,
            let serialNumber = xml["root"]["device"]["serialNum"].value,
            let softwareVersion = xml["root"]["device"]["softwareVersion"].value,
            let hardwareVersion = xml["root"]["device"]["hardwareVersion"].value else { return nil }
        return DeviceDescription(name: name, modalNumber: modalNumber, modalName: modalName, modalIcon: modalIcon, serialNumber: serialNumber, softwareVersion: softwareVersion, hardwareVersion: hardwareVersion)
    }
}
