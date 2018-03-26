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
        guard let model = self.model, let textLabel = self.textLabel else { return }
        
        model.name
            .asObservable()
            .bind(to: textLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}
