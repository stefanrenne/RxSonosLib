//
//  GroupRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class GroupRepositoryImpl: GroupRepository {
    
    func getGroups(for rooms: [Room]) -> Observable<[Group]> {
        guard let firstRoom = rooms.first else { return Observable<[Group]>.just([]) }
        
        return GetGroupsNetwork(room: firstRoom)
            .executeSoapRequest()
            .map(self.mapGroupDataToGroups(rooms: rooms))
    }
    
}

fileprivate extension GroupRepositoryImpl {
    
    fileprivate func mapGroupDataToGroups(rooms: [Room]) -> (([String: String]) throws -> [Group]) {
        return { results in
            
            var groups = [Group]()
            
            let xml = AEXMLDocument.create(results["ZoneGroupState"])
            
            xml?["ZoneGroups"].children.forEach({ (zone) in
                
                if let coordinatorUuid = zone.attributes["Coordinator"],
                    let coordinator = rooms.filter({ $0.uuid == coordinatorUuid }).first {
                    var slaves = [Room]()
                    
                    zone["ZoneGroupMember"].all?.forEach({ (member) in
                        if let roomUuid = member.attributes["UUID"], roomUuid != coordinatorUuid,
                            member.attributes["Invisible"] == nil,
                            let slave = rooms.filter({ $0.uuid == roomUuid }).first {
                            slaves.append(slave)
                        }
                        
                        let satellites = member["Satellite"].all ?? []
                        for satellite in satellites {
                            if let satelliteUuid = satellite.attributes["UUID"],
                                satelliteUuid != coordinatorUuid,
                                satellite.attributes["Invisible"] == nil,
                                let satellite = rooms.filter({ $0.uuid == satelliteUuid }).first {
                                slaves.append(satellite)
                            }
                        }
                    })
                    groups.append(Group(master: coordinator, slaves: slaves))
                }
            })
            
            return groups
        }
    }
}
