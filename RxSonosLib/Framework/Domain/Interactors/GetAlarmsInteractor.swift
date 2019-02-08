//
//  GetAlarmsInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetAlarmsValues: RequestValues {
    let room: Room?
}

class GetAlarmsInteractor: SingleInteractor {
    
    var requestValues: GetAlarmsValues?
    
    private let alarmRepository: AlarmRepository
    
    init(alarmRepository: AlarmRepository) {
        self.alarmRepository = alarmRepository
    }
    
    func setup(values: GetAlarmsValues?) -> Single<[Alarm]> {
        guard let room = values?.room else {
            return Single.error(SonosError.invalidImplementation)
        }
        
        return alarmRepository
            .getAlarmItems(for: room)
    }
    
}
