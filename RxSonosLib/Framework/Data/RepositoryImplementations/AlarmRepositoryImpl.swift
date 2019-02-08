//
//  AlarmRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class AlarmRepositoryImpl: AlarmRepository {
    
    private let network = LocalNetwork<AlarmTarget>()
    
    func getAlarmItems(for room: Room) -> Single<[Alarm]> {
        return network
            .request(.list, on: room)
            .map(mapDataToAlarms)
    }
    
}

private extension AlarmRepositoryImpl {
    
    func mapDataToAlarms(data: [String: String]) throws -> [Alarm] {
        let xml = try AEXMLDocument.create(data["CurrentAlarmList"])
        return try xml?["Alarms"].children.compactMap(mapAlarm) ?? []
    }
    
    func mapAlarm(element: AEXMLElement) throws -> Alarm? {
        guard let enabledString = element.attributes["Enabled"],
            let startTime = element.attributes["StartTime"],
            let duration = element.attributes["Duration"],
            let recurrenceString = element.attributes["Recurrence"],
            let recurrence = Recurrence(rawValue: recurrenceString),
            let programURI = element.attributes["ProgramURI"],
            let playModeString = element.attributes["PlayMode"],
            let playMode = PlayMode(rawValue: playModeString),
            let includeLinkedZonesString = element.attributes["IncludeLinkedZones"],
            let idString = element.attributes["ID"],
            let id = Int(idString),
            let roomUUID = element.attributes["RoomUUID"],
            let volumeString = element.attributes["Volume"],
            let volume = Int(volumeString) else {
                return nil
        }
        let enabled = enabledString == "1"
        let includeLinkedZones = includeLinkedZonesString == "1"
        let metaData = try processMetaData(string: element.attributes["ProgramMetaData"])
        
        return Alarm(id: id, enabled: enabled, startTime: startTime, duration: duration, recurrence: recurrence, programURI: programURI, playMode: playMode, includeLinkedZones: includeLinkedZones, roomUUID: roomUUID, metaData: metaData, volume: volume)
    }
    
    func processMetaData(string: String?) throws -> [String: String]? {
        guard let string = string,
              let metaData = try AEXMLDocument.create(string)?.mapMetaItems().first else { return nil }
        return metaData
    }
}
