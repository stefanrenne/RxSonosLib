//
//  Network.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol Network {
    func perform(request: URLRequest) -> Single<Data>
}

extension Network {
    func perform(request: URLRequest) -> Single<Data> {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        return Single.create { (event) -> Disposable in
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        event(.error(error))
                        return
                    }
                    
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                        statusCode == 200 || statusCode == 204 else {
                            event(.error(NSError.sonosLibUnknownUrlError()))
                            return
                    }
                    
                    guard let data = data, data.count > 0 else {
                        event(.error(NSError.sonosLibInvalidDataError()))
                        return
                    }
                    
                    event(.success(data))
                }
                task.resume()
                return Disposables.create()
            }
            .do(onDispose: {
                session.invalidateAndCancel()
            })
    }
    
}
