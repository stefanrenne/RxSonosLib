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
    @IBOutlet var queueLabel: UILabel!
    var disposeBag = DisposeBag()
    var model: QueueViewModel? {
        didSet {
            self.bindObservables()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    fileprivate func bindObservables() {
        
        queueLabel.text = model?.description ?? nil
        
        guard let model = self.model else { return }
        
        model
            .image
            .bind(to: queueImage.rx.image)
            .disposed(by: disposeBag)
    }
    
}
