//
//  ActionButton.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 15/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxSonosLib

@IBDesignable class ActionButton: UIButton {
    
    let data: BehaviorSubject<TransportState> = BehaviorSubject(value: .transitioning)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        data
            .asObserver()
            .subscribe(onNext: { [weak self] state in
                switch state.reverseState() {
                case .playing, .transitioning:
                    self?.setImage(UIImage(named: "icon_play_large"), for: .normal)
                case .paused:
                    self?.setImage(UIImage(named: "icon_pause_large"), for: .normal)
                case .stopped:
                    self?.setImage(UIImage(named: "icon_stop_large"), for: .normal)
                }
        }).disposed(by: disposeBag)
        
        self
            .rx
            .controlEvent(UIControl.Event.touchUpInside)
            .map({ [weak self] _ in
                guard let state = try self?.data.value() else { return TransportState.transitioning }
                let newState = state.reverseState()
                return newState
            })
            .subscribe(data)
            .disposed(by: disposeBag)
    }
    
}
