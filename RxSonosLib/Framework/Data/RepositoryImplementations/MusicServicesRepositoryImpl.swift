//
//  MusicServicesRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class MusicServicesRepositoryImpl: MusicServicesRepository {
    
    func getMusicServices(for room: Room) -> Observable<[MusicService]> {
        return GetAvailableServicesNetwork(room: room)
            .executeSoapRequest()
            .map(self.mapDataToMusicServices())
    }
    
}

fileprivate extension MusicServicesRepositoryImpl {
    func mapDataToMusicServices() -> (([String: String]) -> [MusicService]) {
        return { data in
            guard let xml = AEXMLDocument.create(data["AvailableServiceDescriptorList"]),
                  let availableServices = data["AvailableServiceTypeList"]?
                    .split(separator: ",")
                    .map({ String($0) }) else {
                return []
            }
            
            return xml["Services"]
                .children
                .compactMap(self.mapService(allowedServices: availableServices))
        }
    }
    
    func mapService(allowedServices: [String]) -> ((AEXMLElement) -> MusicService?) {
        return { element in
            guard let idString = element.attributes["Id"],
                  let id = Int(idString),
                  allowedServices.contains("\(id*256+7)"),
                  let name = element.attributes["Name"],
                  let secureUriString = element.attributes["SecureUri"],
                  let secureUri = URL(string: secureUriString),
                  let typeString = element.attributes["ContainerType"],
                  let type = ContainerType(rawValue: typeString),
                  let policyString = element["Policy"].attributes["Auth"],
                  let policy = AuthenticationPolicy(rawValue: policyString),
                  let presentationMapVersionString = element["Presentation"]["PresentationMap"].attributes["Version"],
                  let presentationMapVersion = Int(presentationMapVersionString),
                  let presentationMapUriString = element["Presentation"]["PresentationMap"].attributes["Uri"],
                  let presentationMapUri = URL(string: presentationMapUriString) else {
                return nil
            }
            
            var strings: Presentation?
            if let presentationStringsVersionString = element["Presentation"]["Strings"].attributes["Version"],
                let presentationStringsVersion = Int(presentationStringsVersionString),
                let presentationStringsUriString = element["Presentation"]["Strings"].attributes["Uri"],
                let presentationStringsUri = URL(string: presentationStringsUriString) {
                strings = Presentation(uri: presentationStringsUri, version: presentationStringsVersion)
            }
            
            let presentationMap = Presentation(uri: presentationMapUri, version: presentationMapVersion)
            
            return MusicService(id: id, name: name, uri: secureUri, type: type, policy: policy, map: presentationMap, strings: strings)
        }
    }
}
