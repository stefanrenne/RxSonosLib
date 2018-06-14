//
//  NowPlayingViewController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 13/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSonosLib

class NowPlayingViewController: UIViewController {
    
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupTrackTitle: UILabel!
    @IBOutlet var groupTrackDescription: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressTime: UILabel!
    @IBOutlet var remainingTime: UILabel!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var actionButton: ActionButton!
    
    private let disposeBag = DisposeBag()
    internal var router: NowPlayingRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActiveGroupObservable()
        self.setupNowPlayingObservable()
        self.setupVolumeObservables()
        self.setupMuteObservable()
        self.setupTransportStateObservable()
        self.setupGroupProgressObservable()
        self.setupImageObservable()
    }
    
    fileprivate func setupActiveGroupObservable() {
        SonosInteractor
            .getActiveGroup()
            .subscribe(onNext: { [weak self] (group) in
                self?.groupNameLabel.text = group.name
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupNowPlayingObservable() {
        self.resetTrack()
        
        SonosInteractor
            .getActiveGroup()
            .getTrack()
            .subscribe(onNext: { [weak self] (track) in
                guard let track = track else {
                    self?.groupTrackTitle.text = nil
                    self?.groupTrackDescription.text = nil
                    return
                }
                let viewModel = TrackViewModel(track: track)
                self?.groupTrackTitle.text = viewModel.trackTitle
                self?.groupTrackDescription.attributedText = viewModel.trackDescription
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupVolumeObservables() {
        SonosInteractor
            .getActiveGroup()
            .getVolume()
            .filter({ _ in return !self.volumeSlider.isTouchInside })
            .subscribe(onNext: { [weak self] (volume) in
                self?.volumeSlider.value = Float(volume) / 100.0
            })
            .disposed(by: disposeBag)
        
        volumeSlider
            .rx
            .value
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ _ in return self.volumeSlider.isTouchInside })
            .flatMap({ (newVolume) -> Observable<Int> in
                return SonosInteractor
                    .getActiveGroup()
                    .set(volume: Int(newVolume * 100.0))
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupMuteObservable() {
        SonosInteractor
            .getActiveGroup()
            .getMute()
            .subscribe(onNext: { [weak self] (muted) in
                self?.muteButton.isSelected = muted.first!
            })
            .disposed(by: disposeBag)
        
        muteButton
            .rx
            .controlEvent(UIControlEvents.touchUpInside)
            .filter({ _ in return self.muteButton.isTouchInside })
            .map({ (_) -> Bool in
                return !self.muteButton.isSelected
            })
            .flatMap({ [weak self] (isMuted) -> Observable<[Bool]> in
                self?.muteButton.isSelected = isMuted
                return SonosInteractor
                    .getActiveGroup()
                    .set(mute: isMuted)
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupTransportStateObservable() {
        SonosInteractor
         .getActiveGroup()
         .getTransportState()
         .subscribe(self.actionButton.data)
         .disposed(by: disposeBag)
        
        actionButton
            .data
            .filter({ _ in return self.actionButton.isTouchInside })
            .flatMap({ (newState) -> Observable<TransportState> in
                return SonosInteractor
                    .getActiveGroup()
                    .set(transportState: newState)
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupGroupProgressObservable() {
        SonosInteractor
            .getActiveGroup()
            .getProgress()
            .subscribe(onNext: { [weak self] (progress) in
                self?.progressTime.text = progress.timeString
                self?.remainingTime.text = progress.remainingTimeString
                self?.progressView.progress = progress.progress
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupImageObservable() {
        SonosInteractor
            .getActiveGroup()
            .getImage()
            .catchErrorJustReturn(nil)
            .map({ (data) -> UIImage? in
                guard let data = data, let image = UIImage(data: data) else { return nil }
                return image
            })
            .bind(to: groupImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    fileprivate func resetTrack() {
        self.groupTrackTitle.text = ""
        self.groupTrackDescription.text = ""
        self.progressTime.text = nil
        self.remainingTime.text = nil
        self.progressView.progress = 0
        self.groupImageView.image = nil
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        router?.close()
    }
    
    @IBAction func queueAction(_ sender: UIButton) {
        self.router?.continueToQueue()
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        SonosInteractor
            .getActiveGroup()
            .setPreviousTrack()
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        SonosInteractor
            .getActiveGroup()
            .setNextTrack()
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
