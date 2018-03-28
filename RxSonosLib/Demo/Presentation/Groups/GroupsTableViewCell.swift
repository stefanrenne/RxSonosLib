//
//  GroupsTableViewCell.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet var groupTitleLabel: UILabel!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupDescriptionLabel: UILabel!
    
    static let identifier = "cell"
    var disposeBag = DisposeBag()
    var model: GroupViewModel? {
        didSet {
            self.bindObservables()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    fileprivate func bindObservables() {
        
        self.resetTitle()
        self.resetTrack()
        
        guard let model = self.model else { return }
        
        model.name
            .asObservable()
            .bind(to: groupTitleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        model.nowPlayingInteractor.subscribe(onNext: { [weak self] (track) in
            self?.bind(track: TrackViewModel(track: track))
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        .disposed(by: self.disposeBag)
    }
    
    fileprivate func bind(track: TrackViewModel) {
        self.groupDescriptionLabel.text = track.description
        
        track.image
            .bind(to: groupImageView.rx.image)
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func resetTitle() {
        self.groupTitleLabel.text = nil
    }
    
    fileprivate func resetTrack() {
        self.groupDescriptionLabel.text = "-"
        self.groupImageView.image = nil
    }
    
}
