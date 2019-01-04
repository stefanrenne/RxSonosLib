//
//  MoreTableViewCell.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift

class MoreTableViewCell: UITableViewCell {

    static let identifier = "cell"
    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!
    var disposeBag = DisposeBag()
    var model: MoreViewModel? {
        didSet {
            self.label.text = model?.title
            self.icon.image = model?.icon
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
