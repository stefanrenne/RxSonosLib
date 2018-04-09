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
    
    static let identifier = "cell"
    var disposeBag = DisposeBag()
    var group: Group! {
        didSet {
            self.groupTitleLabel.text = self.group?.name
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
                let viewModel = TrackViewModel(track: track)
                self?.bind(viewModel: viewModel)
            }, onError: { [weak self] (error) in
                self?.groupDescriptionLabel.text = nil
                self?.groupImageView.image = nil
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func bind(viewModel: TrackViewModel) {
        self.groupDescriptionLabel.attributedText = viewModel.trackDescription
        
        viewModel
            .image
            .bind(to: groupImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
}
