//
//  MusicServicesTableViewCell.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift

class MusicServicesTableViewCell: UITableViewCell {

    static let identifier = "cell"
    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!
    var disposeBag = DisposeBag()
    var model: MusicServiceViewModel? {
        didSet {
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
