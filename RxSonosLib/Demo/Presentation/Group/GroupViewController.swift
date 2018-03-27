//
//  GroupViewController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 13/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSonosLib

class GroupViewController: UIViewController {
    
    var group: Group!
    private let disposeBag = DisposeBag()
    private let getNowPlayingInteractor: GetNowPlayingInteractor = SonosInteractor.provideNowPlayingInteractor()
    internal var router: GroupRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNowPlaying()
    }
    
    fileprivate func setupNowPlaying() {
        getNowPlayingInteractor
            .get(values: GetNowPlayingValues(group: group))
            .subscribe(onNext: { (track) in
                print("groups: onNext")
            }, onError: { (error) in
                print("groups: \(error.localizedDescription)")
            }, onCompleted: {
                print("groups: onCompleted")
            })
            .disposed(by: disposeBag)
    }

}
