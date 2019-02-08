//
//  GetGroupQueueInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetGroupQueueValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetGroupQueueInteractor: ObservableInteractor {
    
    var requestValues: GetGroupQueueValues?
    
    private let contentDirectoryRepository: ContentDirectoryRepository
    
    init(contentDirectoryRepository: ContentDirectoryRepository) {
        self.contentDirectoryRepository = contentDirectoryRepository
    }
    
    func setup(values: GetGroupQueueValues?) -> Observable<[MusicProviderTrack]> {
        
        guard let masterRoom = values?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupQueueTimer)
            .flatMap(mapToQueue(for: masterRoom))
            .distinctUntilChanged()
    }
}

private extension GetGroupQueueInteractor {
    func mapToQueue(for masterRoom: Room) -> ((Int) -> Observable<[MusicProviderTrack]>) {
        return { _ in
            return self.contentDirectoryRepository
                .getQueue(for: masterRoom)
                .asObservable()
        }
    }
}
