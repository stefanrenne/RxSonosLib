//
//  GroupViewModel.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSonosLib

class GroupViewModel {
    
    fileprivate let group: Group
    fileprivate var disposeBag = DisposeBag()
    
    init(group: Group) {
        self.group = group
    }
    
    var name: BehaviorSubject<String> { return group.name }
    
    lazy var nowPlayingInteractor: Observable<Track> = {
        return SonosInteractor.provideNowPlayingInteractor()
            .get(values: GetNowPlayingValues(group: group))
    }()
    
    lazy var transportStateInteractor: Observable<TransportState> = {
        return SonosInteractor.provideTransportStateInteractor()
            .get(values: GetTransportStateValues(group: group))
    }()
    
    lazy var groupProgressInteractor: Observable<GroupProgress> = {
        return SonosInteractor.provideGroupProgressInteractor()
            .get(values: GetGroupProgressValues(group: group))
    }()
}
