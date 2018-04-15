//
//  TabBarViewController.swift
//  Demo App
//
//  Created by Stefan Renne on 06/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxSonosLib

class TabBarViewController: UIViewController {
    
    internal var actions: TabBarActions?
    internal var router: TabBarRouter?
    @IBOutlet var contentView: UIView!
    @IBOutlet var nowPlayingView: UIView!
    @IBOutlet var nowPlayingHeightConstraint: NSLayoutConstraint!
    @IBOutlet var nowPlayingTopConstraint: NSLayoutConstraint!
    @IBOutlet var fullNowPlayingView: UIView!
    @IBOutlet var compactNowPlayingView: UIView!
    @IBOutlet var nowPlayingTitleLabel: UILabel!
    @IBOutlet var nowPlayingDescriptionLabel: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var actionButton: ActionButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actions?.didLoad()
        self.setupTabBar()
        self.setupActiveGroupObservable()
        self.setupNowPlayingObservable()
        self.setupTransportStateObservable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        router?.continueToNowPlaying()
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        self.nowPlayingAction(collapse: false)
    }
    
    internal func nowPlayingAction(collapse: Bool) {
        nowPlayingTopConstraint.isActive = !collapse
        nowPlayingHeightConstraint.isActive = collapse
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
            UIApplication.shared.statusBarStyle = collapse ? .default : .lightContent
            self.compactNowPlayingView.alpha = collapse ? 1 : 0
            self.fullNowPlayingView.alpha = collapse ? 0 : 1
            self.view.backgroundColor = collapse ? UIColor.white : UIColor.black
        })
    }
    
    fileprivate func setupTabBar() {
        tabBar.selectedItem = tabBar.items?.first
        router?.continueToMySonos()
        
        tabBar
            .rx
            .didSelectItem
            .do(onNext: { [weak self] (_) in
                self?.nowPlayingAction(collapse: true)
            })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (item) in
                switch item.tag {
                    case 1: self?.router?.continueToMySonos(); break
                    case 2: self?.router?.continueToBrowse(); break
                    case 3: self?.router?.continueToRooms(); break
                    case 4: self?.router?.continueToSearch(); break
                    case 5: self?.router?.continueToMore(); break
                    default: break
                }
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupActiveGroupObservable() {
        SonosInteractor
            .getActiveGroup()
            .subscribe(onNext: { [weak self] (group) in
                self?.nowPlayingDescriptionLabel.text = group?.name
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupNowPlayingObservable() {
        SonosInteractor
            .getActiveTrack()
            .subscribe(onNext: { [weak self] (track) in
                guard let track = track else {
                    self?.nowPlayingTitleLabel.text = nil
                    return
                }
                let viewModel = TrackViewModel(track: track)
                self?.nowPlayingTitleLabel.attributedText = viewModel.trackGroupDescription
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupTransportStateObservable() {
        SonosInteractor
            .getActiveTransportState()
            .subscribe(self.actionButton.data)
            .disposed(by: disposeBag)
        
        actionButton
            .data
            .filter({ _ in return self.actionButton.isTouchInside })
            .flatMap({ (newState, _) -> Observable<Void> in
                return SonosInteractor
                    .setActiveTransport(state: newState)
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

}
