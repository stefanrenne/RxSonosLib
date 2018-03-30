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
    fileprivate var time: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    fileprivate var duration: Int = 0
    fileprivate var disposeBag = DisposeBag()
    
    init(group: Group) {
        self.group = group
    }
    
    var name: BehaviorSubject<String> { return group.name }
    
    lazy var nowPlayingInteractor: Observable<Track> = {
        return SonosInteractor.provideNowPlayingInteractor()
            .get(values: GetNowPlayingValues(group: group))
            .do(onNext: { [weak self] (track) in
                self?.time.onNext(track.time)
                self?.duration = track.duration
            })
    }()
    
    lazy var transportStateInteractor: Observable<TransportState> = {
        return SonosInteractor.provideTransportStateInteractor()
            .get(values: GetTransportStateValues(group: group))
            .do(onNext: { [weak self] (state) in
                if state == .playing {
                    self?.startTimer()
                } else {
                    self?.stopTimer()
                }
                if state == .stopped || state == .transitioning {
                    self?.resetTime()
                }
            })
    }()
    
    lazy var progressTime: Observable<String?> = {
        return self.time.asObservable().map({ $0.toTimeString() })
    }()
    
    lazy var remainingTime: Observable<String?> = {
        return self.time.asObservable().map({
            let remainingTime = self.self.duration - $0
            guard remainingTime > 0 else { return "0:00" }
            return "-" + remainingTime.toTimeString()
        })
    }()
    
    lazy var trackProgress: Observable<Float> = {
        return self.time.asObservable().map({ Float($0) / Float(self.self.duration) })
    }()
}

fileprivate extension GroupViewModel {
    func startTimer() {
        
        self.timeTick()
        
        Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.timeTick()
            })
            .disposed(by: self.disposeBag)
    }
    
    func resetTime() {
        self.time.onNext(0)
    }
    
    func stopTimer() {
        self.disposeBag = DisposeBag()
    }
    
    func timeTick() {
        let newValue = try! self.time.value().advanced(by: 1)
        guard newValue <= self.duration else { return }
        self.time.onNext(newValue)
    }
}

fileprivate extension Int {
    func toTimeString() -> String {
        var totalSeconds = self
        let totalHours = totalSeconds / (60 * 60)
        totalSeconds -= totalHours * 60 * 60
        let totalMinutes = totalSeconds / 60
        totalSeconds -= totalMinutes * 60
        
        if totalHours > 0 {
            return "\(totalHours):" + String(format: "%02d", totalMinutes) + ":" + String(format: "%02d", totalSeconds)
        } else {
            return "\(totalMinutes):" + String(format: "%02d", totalSeconds)
        }
    }
}
