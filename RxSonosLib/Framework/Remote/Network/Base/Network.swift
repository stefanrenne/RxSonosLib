//
//  Network.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class Network {
    
    let cacheKey: String?
    
    init(cacheKey: String? = nil) {
        self.cacheKey = cacheKey
    }
    
    func executeRequest() -> Observable<Data> {
        
        return Observable<Data>.create { (observable) -> Disposable in
            
            let cachedData: Data? = CacheManager.shared.get(for: self.cacheKey)
            if let data = cachedData {
                observable.onNext(data)
            }
            
            if self.shouldPerformRequest(hasCache: (cachedData != nil)),
                let request = self.createRequest() {
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: self.handleCompletion(observer: observable, cachedData: cachedData))
                task.resume()
                
            } else {
                // No Internet, but there possible is cached data
                if cachedData == nil {
                    observable.onError(NSError.sonosLibNoDataError())
                } else {
                    observable.onCompleted()
                }
            }
            
            return Disposables.create()
        }
        
    }
    
    func createRequest() -> URLRequest? {
        //overwride in subclass
        return nil
    }
    
    func shouldPerformRequest(hasCache: Bool) -> Bool {
        return RxReachability.hasInternet
    }
    
    func handleCompletion(observer: AnyObserver<Data>, cachedData: Data?) -> ((Data?, URLResponse?, Error?) -> Void) {
        return { (data, response, error) in
            
            if let error = error {
                observer.onError(error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode == 200 || statusCode == 204 else {
                    observer.onError(NSError.sonosLibUnknownUrlError())
                    return
            }
            
            guard let data = data, data.count > 0 else {
                observer.onError(NSError.sonosLibInvalidDataError())
                return
            }
            
            if cachedData == nil || data.hexString != cachedData!.hexString {
                
                print(String(data: data, encoding: .utf8)!)
                
                observer.onNext(data)
                CacheManager.shared.set(data, for: self.cacheKey)
            }
            observer.onCompleted()
        }
    }
    
}
