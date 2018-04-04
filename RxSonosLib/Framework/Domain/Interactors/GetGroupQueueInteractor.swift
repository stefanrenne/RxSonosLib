//
//  GetGroupQueueInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class GetGroupQueueValues: RequestValues {
    let group: Group
    
    public init(group: Group) {
        self.group = group
    }
}

open class GetGroupQueueInteractor: BaseInteractor<GetGroupQueueValues, [Track]> {
    
    let contentDirectoryRepository: ContentDirectoryRepository
    
    public init(contentDirectoryRepository: ContentDirectoryRepository) {
        self.contentDirectoryRepository = contentDirectoryRepository
    }
    
    override func buildInteractorObservable(requestValues: GetGroupQueueValues?) -> Observable<[Track]> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(2)
            .flatMap(self.mapToQueue(for: masterRoom))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToQueue(for masterRoom: Room) -> (() -> Observable<[Track]>) {
        return {
            return self.contentDirectoryRepository
                .getQueue(for: masterRoom)
        }
    }
}


