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
        self.disposeBag = DisposeBag()
    }
    
    fileprivate func bindTrackObservable() {
        group
            .getTrack()
            .subscribe(onNext: { [weak self] (track) in
                self?.bind(track: track)
            }, onError: { [weak self] (error) in
                self?.groupDescriptionLabel.text = nil
                self?.groupImageView.image = nil
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func bind(track: Track?) {
        guard let track = track else {
            self.groupDescriptionLabel.text = "[No Track]"
            groupImageView.image = nil
            return
        }
        let viewModel = TrackViewModel(track: track)
        self.groupDescriptionLabel.attributedText = viewModel.trackDescription
        
        viewModel
            .image
            .bind(to: groupImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
}
