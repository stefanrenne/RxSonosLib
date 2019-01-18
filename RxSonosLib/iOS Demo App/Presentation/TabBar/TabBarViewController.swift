//
//  TabBarViewController.swift
//  iOS Demo App
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
    @IBOutlet var nowPlayingHeightConstraint: NSLayoutConstraint?
    @IBOutlet var nowPlayingTopConstraint: NSLayoutConstraint?
    @IBOutlet var fullNowPlayingView: UIView!
    @IBOutlet var compactNowPlayingView: UIView!
    @IBOutlet var nowPlayingTitleLabel: UILabel!
    @IBOutlet var nowPlayingDescriptionLabel: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var actionButton: ActionButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions?.didLoad()
        setupTabBar()
        setupActiveGroupObservable()
        setupNowPlayingObservable()
        setupTransportStateObservable()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let collapse = nowPlayingHeightConstraint?.isActive ?? false
        return collapse ? .default : .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        nowPlayingAction(collapse: false)
    }
    
    internal func nowPlayingAction(collapse: Bool) {
        nowPlayingTopConstraint?.isActive = !collapse
        nowPlayingHeightConstraint?.isActive = collapse
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.setNeedsStatusBarAppearanceUpdate()
            self?.compactNowPlayingView.alpha = collapse ? 1 : 0
            self?.fullNowPlayingView.alpha = collapse ? 0 : 1
            self?.view.backgroundColor = collapse ? UIColor.white : UIColor.black
        }
    }
    
    private func setupTabBar() {
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
                case 1: self?.router?.continueToMySonos()
                case 2: self?.router?.continueToBrowse()
                case 3: self?.router?.continueToRooms()
                case 4: self?.router?.continueToSearch()
                case 5: self?.router?.continueToMore()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupActiveGroupObservable() {
        SonosInteractor
            .getActiveGroup()
            .subscribe(onNext: { [weak self] (group) in
                self?.actions?.didUpdateActiveGroup()
                self?.nowPlayingDescriptionLabel.text = group.name
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNowPlayingObservable() {
        SonosInteractor
            .getActiveGroup()
            .getTrack()
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
    
    private func setupTransportStateObservable() {
        SonosInteractor
            .getActiveGroup()
            .getTransportState()
            .subscribe(actionButton.data)
            .disposed(by: disposeBag)
        
        actionButton
            .data
            .filter({ _ in return self.actionButton.isTouchInside })
            .flatMap({ (state) -> Completable in
                return SonosInteractor
                    .getActiveGroup()
                    .set(transportState: state)
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

}
