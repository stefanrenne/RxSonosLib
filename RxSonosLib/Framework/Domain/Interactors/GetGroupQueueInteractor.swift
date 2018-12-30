//
//  GetGroupQueueInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetGroupQueueValues: RequestValues {
    let group: Group
}

class GetGroupQueueInteractor: ObservableInteractor {
    
    var requestValues: GetGroupQueueValues?
    
    private let contentDirectoryRepository: ContentDirectoryRepository
    
    init(contentDirectoryRepository: ContentDirectoryRepository) {
        self.contentDirectoryRepository = contentDirectoryRepository
    }
    
    func buildInteractorObservable(values: GetGroupQueueValues?) -> Observable<[MusicProviderTrack]> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupQueueTimer)
            .flatMap(self.mapToQueue(for: masterRoom))
            .distinctUntilChanged()
    }
    
    fileprivate func mapToQueue(for masterRoom: Room) -> ((Int) -> Observable<[MusicProviderTrack]>) {
        return { _ in
            return self.contentDirectoryRepository
                .getQueue(for: masterRoom)
                .asObservable()
        }
    }
}
