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
    
    var model: GroupViewModel!
    
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupDescription: UILabel!
    
    private let disposeBag = DisposeBag()
    private let getNowPlayingInteractor: GetNowPlayingInteractor = SonosInteractor.provideNowPlayingInteractor()
    internal var router: GroupRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupName()
        self.setupNowPlaying()
    }
    
    fileprivate func setupName() {
        model.name
            .asObservable()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func setupNowPlaying() {
        
        model.nowPlayingInteractor.subscribe(onNext: { [weak self] (track) in
            guard let track = track else {
                self?.resetTrack()
                return
            }
            self?.bind(track: TrackViewModel(track: track))
            
            }, onError: { [weak self] (error) in
                print(error.localizedDescription)
                self?.resetTrack()
            })
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func bind(track: TrackViewModel) {
        self.groupDescription.text = track.description
        self.groupImageView.image = nil
        
        track.image
            .bind(to: groupImageView.rx.image)
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func resetTrack() {
        self.groupDescription.text = "-"
        self.groupImageView.image = nil
    }

}
