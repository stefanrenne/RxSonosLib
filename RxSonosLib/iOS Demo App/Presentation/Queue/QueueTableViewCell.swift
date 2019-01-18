//
//  QueueTableViewCell.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift

class QueueTableViewCell: UITableViewCell {
    
    static let identifier = "cell"
    @IBOutlet var queueImage: UIImageView!
    @IBOutlet var queueTitleLabel: UILabel!
    @IBOutlet var queueDescriptionLabel: UILabel!
    var disposeBag = DisposeBag()
    var model: TrackViewModel? {
        didSet {
            self.bindObservables()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func bindObservables() {
        
        queueTitleLabel.text = model?.trackTitle
        queueDescriptionLabel.text = model?.trackArtists
        
        guard let model = self.model else { return }
        
        model
            .image
            .bind(to: queueImage.rx.image)
            .disposed(by: disposeBag)
    }
    
}
