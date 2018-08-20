//
//  RoomsViewController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSonosLib

class RoomsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    internal var router: RoomsRouter?

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rooms"
        
        self.setupTableViewItems()
        self.setupCellTapHandling()
    }
    
    func setupTableViewItems() {
        table.register(UINib(nibName: String(describing: RoomsTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: RoomsTableViewCell.identifier)
        
        SonosInteractor
            .getAllGroups()
            .bind(to: table.rx.items(cellIdentifier: RoomsTableViewCell.identifier, cellType: RoomsTableViewCell.self)) { (_, group, cell) in
                cell.group = group
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        table
            .rx
            .modelSelected(Group.self)
            .subscribe(onNext: { [weak self] (group) in
                SonosInteractor.setActive(group: group)
                self?.router?.continueTo(group: group)
            })
            .disposed(by: self.disposeBag)
    }
    
}
