//
//  MusicProvidersTableViewCell.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift

class MusicProvidersTableViewCell: UITableViewCell {

    static let identifier = "cell"
    @IBOutlet var icon: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var disposeBag = DisposeBag()
    var model: MusicProviderViewModel? {
        didSet {
            titleLabel.text = model?.name
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
