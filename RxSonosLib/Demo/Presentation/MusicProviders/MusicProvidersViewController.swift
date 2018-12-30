//
//  MusicProvidersViewController.swift
//  Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift
import RxCocoa

class MusicProvidersViewController: UIViewController {
    
    internal var router: MusicProvidersRouter!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var navigationItemDone: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "MusicProviders"
        
        self.setupNavigationBar()
        self.setupTableViewItems()
        self.setupCellTapHandling()
        self.setupCloseButton()
    }
    
    func setupTableViewItems() {
        table.register(UINib(nibName: String(describing: MusicProvidersTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: MusicProvidersTableViewCell.identifier)
        
        SonosInteractor
            .getAllMusicProviders()
            .asObservable()
            .bind(to: table.rx.items(cellIdentifier: MusicProvidersTableViewCell.identifier, cellType: MusicProvidersTableViewCell.self)) { (_, service, cell) in
                cell.model = MusicProviderViewModel(service: service)
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        table
            .rx
            .modelSelected(MusicProvider.self)
            .subscribe(onNext: { [weak self] (service) in
                self?.router.didSelect(service: service)
            })
            .disposed(by: disposeBag)
    }
    
    func setupNavigationBar() {
        navigationBar.styleWhite()
    }
    
    func setupCloseButton() {
        navigationItemDone.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.router.didClose()
        }).disposed(by: disposeBag)
    }

}
