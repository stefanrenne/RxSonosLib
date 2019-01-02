//
//  MusicProvidersRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class MusicProvidersRepositoryImpl: MusicProvidersRepository {
    
    private let network = LocalNetwork<MusicTarget>()
    
    func getMusicProviders(for room: Room) -> Single<[MusicProvider]> {
        return network
            .request(.listAvailableServices, on: room)
            .map(self.mapDataToMusicServices())
    }
    
}

fileprivate extension MusicProvidersRepositoryImpl {
    func mapDataToMusicServices() -> (([String: String]) throws -> [MusicProvider]) {
        return { data in
            let xml = try AEXMLDocument.create(data["AvailableServiceDescriptorList"])
            return xml?["Services"].children.compactMap(self.mapService()) ?? []
        }
    }
    
    func mapService() -> ((AEXMLElement) -> MusicProvider?) {
        return { element in
            guard let idString = element.attributes["Id"],
                  let id = Int(idString),
                  let name = element.attributes["Name"],
                  let secureUriString = element.attributes["SecureUri"],
                  let secureUri = URL(string: secureUriString),
                  let typeString = element.attributes["ContainerType"],
                  let type = ContainerType(rawValue: typeString),
                  let policyString = element["Policy"].attributes["Auth"],
                  let policy = AuthenticationPolicy(rawValue: policyString) else {
                return nil
            }
            
            var presentationMap: Presentation?
            if let presentationMapVersionString = element["Presentation"]["PresentationMap"].attributes["Version"],
                let presentationMapVersion = Int(presentationMapVersionString),
                let presentationMapUriString = element["Presentation"]["PresentationMap"].attributes["Uri"],
                let presentationMapUri = URL(string: presentationMapUriString) {
                presentationMap = Presentation(uri: presentationMapUri, version: presentationMapVersion)
            }
            
            var strings: Presentation?
            if let presentationStringsVersionString = element["Presentation"]["Strings"].attributes["Version"],
                let presentationStringsVersion = Int(presentationStringsVersionString),
                let presentationStringsUriString = element["Presentation"]["Strings"].attributes["Uri"],
                let presentationStringsUri = URL(string: presentationStringsUriString) {
                strings = Presentation(uri: presentationStringsUri, version: presentationStringsVersion)
            }
            
            let service = MusicProvider(id: id, name: name, uri: secureUri, type: type, policy: policy, map: presentationMap, strings: strings)
            
            return service
            
        }
    }
}
