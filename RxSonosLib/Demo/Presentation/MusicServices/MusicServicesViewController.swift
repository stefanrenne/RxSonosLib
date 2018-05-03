//
//  MusicServicesViewController.swift
//  Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift
import RxCocoa

class MusicServicesViewController: UIViewController {
    
    internal var router: MusicServicesRouter!
    @IBOutlet var table: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Musicservices"
        
        self.setupTableViewItems()
        self.setupCellTapHandling()
    }
    
    func setupTableViewItems() {
        table.register(UINib(nibName: String(describing: MusicServicesTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: MusicServicesTableViewCell.identifier)
        
        SonosInteractor
            .getAllMusicServices()
            .do(onNext: { (services) in
              print(services)
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .bind(to: table.rx.items(cellIdentifier: MusicServicesTableViewCell.identifier, cellType: MusicServicesTableViewCell.self)) { (row, service, cell) in
                cell.model = MusicServiceViewModel(service: service)
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        table
            .rx
            .modelSelected(MusicService.self)
            .subscribe(onNext: { [weak self] (service) in
                self?.router.didSelect(service: service)
            })
            .disposed(by: disposeBag)
    }

}
