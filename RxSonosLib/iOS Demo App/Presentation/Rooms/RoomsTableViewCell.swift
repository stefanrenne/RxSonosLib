//
//  RoomsTableViewCell.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift
import RxCocoa

class RoomsTableViewCell: UITableViewCell {
    
    @IBOutlet var groupTitleLabel: UILabel!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupDescriptionLabel: UILabel!
    @IBOutlet var innerBackgroundView: UIView!
    @IBOutlet var groupButton: UIButton!
    
    static let identifier = "cell"
    var disposeBag = DisposeBag()
    var group: Group! {
        didSet {
            self.groupButton.layer.cornerRadius = 5
            self.innerBackgroundView.layer.cornerRadius = 10
            self.innerBackgroundView.layer.borderWidth = 1
            self.innerBackgroundView.layer.borderColor = UIColor.black.cgColor
            self.groupImageView.layer.borderWidth = 1
            self.groupImageView.layer.borderColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.0).cgColor
            self.groupTitleLabel.text = self.group?.names.joined(separator: "\n")
            self.bindTrackObservable()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func bindTrackObservable() {
        Observable
            .just(group)
            .getTrack()
            .subscribe(onNext: { [weak self] (track) in
                self?.bind(track: track)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind(track: Track?) {
        guard let track = track else {
            groupDescriptionLabel.text = "[No Track]"
            groupImageView.image = nil
            return
        }
        let viewModel = TrackViewModel(track: track)
        groupDescriptionLabel.attributedText = viewModel.trackDescription
        
        viewModel
            .image
            .bind(to: groupImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
}
