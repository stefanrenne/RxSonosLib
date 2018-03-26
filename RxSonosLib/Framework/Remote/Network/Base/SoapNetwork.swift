//
//  SoapNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class SoapNetwork: Network {
    
    let room: Room
    let call: SoapSoapAction
    
    init(room: Room, action: SoapSoapAction) {
        self.room = room
        self.call = action
        super.init()
    }
    
    override func createRequest() -> URLRequest? {
        let url = self.room.ip.appendingPathComponent(self.call.service.controllUrl)
        var request = URLRequest(url: url)
        request.setValue(self.room.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        request.httpMethod = "POST"
        request.setValue("\"\(self.call.soapAction)\"", forHTTPHeaderField: "SOAPACTION")
        request.httpBody = self.createBody().data(using: .utf8)
        return request
    }
    
    internal func createBody() -> String {
        var bodyString = "<u:\(call.action) xmlns:u=\"\(call.service.schema)\" />"
        if let arguments = call.arguments {
            bodyString = "<u:\(call.action) xmlns:u=\"\(call.service.schema)\">\(arguments)</u:\(call.action)>"
        }
        return "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body>\(bodyString)</s:Body></s:Envelope>"
    }
    
    func executeSoapRequest() -> Observable<[String:String]> {
        return super.executeRequest()
            .map(self.openEnvelope())
    }
    
    override func executeRequest() -> Observable<Data> {
        fatalError("Use executeSoapRequest() on subclasses of SoapNetwork")
    }
    
    internal func openEnvelope() -> ((Data) throws -> [String:String]) {
        return { data in
            let xml = AEXMLDocument.create(data)
            let element = xml?["Envelope"]["Body"]["\(self.call.action)Response"]
            
            var soapData: [String:String] = [:]
            element?.children.forEach({ (row) in
                soapData[row.name] = row.string
            })
            
            return soapData
        }
    }
}
