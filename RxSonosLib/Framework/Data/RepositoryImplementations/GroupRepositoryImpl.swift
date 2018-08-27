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
    
    func getGroups(for rooms: [Room]) -> Single<[Group]> {
        guard let firstRoom = rooms.first else { return Single<[Group]>.just([]) }
        
        return GetGroupsNetwork(room: firstRoom)
            .executeRequest()
            .map(self.mapGroupDataToGroups(rooms: rooms))
    }
    
}

fileprivate extension GroupRepositoryImpl {
    
    fileprivate func mapGroupDataToGroups(rooms: [Room]) -> (([String: String]) throws -> [Group]) {
        return { results in
            let xml = AEXMLDocument.create(results["ZoneGroupState"])
            return xml?["ZoneGroups"].children.compactMap(self.mapZoneToGroup(rooms: rooms)) ?? []
        }
    }
    
    fileprivate func mapZoneToGroup(rooms: [Room]) -> ((AEXMLElement) -> Group?) {
        return { zone in
            guard let coordinatorUuid = zone.attributes["Coordinator"],
                let coordinator = rooms.filter({ $0.uuid == coordinatorUuid }).first else {
                    return nil
            }
            
            let slaves: [Room] = zone["ZoneGroupMember"]
                .all?
                .map(self.mapMembersToSlaves(coordinatorUuid: coordinatorUuid))
                .reduce([], +)
                .compactMap(self.mapUuidToRoom(rooms: rooms)) ?? []
            return Group(master: coordinator, slaves: slaves)
        }
    }
    
    fileprivate func mapMembersToSlaves(coordinatorUuid: String) -> (((AEXMLElement)) -> [String]) {
        return { member in
            var slaves = [String]()
            if let roomUuid = member.attributes["UUID"], roomUuid != coordinatorUuid,
                member.attributes["Invisible"] == nil {
                slaves.append(roomUuid)
            }
            
            if let satelliteSlaves = member["Satellite"].all?.compactMap(self.mapSatelliteToSlave(coordinatorUuid: coordinatorUuid)) {
                slaves += satelliteSlaves
            }
            return slaves
        }
    }
    
    fileprivate func mapSatelliteToSlave(coordinatorUuid: String) -> (((AEXMLElement)) -> String?) {
        return { satellite in
            guard let satelliteUuid = satellite.attributes["UUID"],
                satelliteUuid != coordinatorUuid,
                satellite.attributes["Invisible"] == nil else {
                    return nil
                }
            return satelliteUuid
        }
    }
    
    fileprivate func mapUuidToRoom(rooms: [Room]) -> (((String)) -> Room?) {
        return { uuid in
            return rooms.filter({ $0.uuid == uuid }).first
        }
    }
}
