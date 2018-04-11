//
//  LoadingViewController.swift
//  Demo App
//
//  Created by Stefan Renne on 09/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift

class LoadingViewController: UIViewController {

    internal var router: LoadingRouter!
    fileprivate let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllRoomsObservable()
    }
    
    fileprivate func setupAllRoomsObservable() {
        SonosInteractor
            .getAllGroups()
            .subscribe(onNext: { [weak self] (groups) in
                if groups.count > 0 {
                    self?.router.continueToMySonos()
                }
            })
            .disposed(by: disposebag)
    }

}
