//
//  MoreViewController.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoreViewController: UIViewController {
    
    internal var router: MoreRouter!
    @IBOutlet var table: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More"
        
        self.setupTableViewItems()
        self.setupCellTapHandling()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupTableViewItems() {
        table.register(UINib(nibName: String(describing: MoreTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: MoreTableViewCell.identifier)
        
        var moreItems = [MoreType]()
        moreItems.append(.musicproviders)
        
        Observable
            .just(moreItems)
            .bind(to: table.rx.items(cellIdentifier: MoreTableViewCell.identifier, cellType: MoreTableViewCell.self)) { (_, type, cell) in
                cell.model = MoreViewModel(type: type)
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        table
            .rx
            .modelSelected(MoreType.self)
            .subscribe(onNext: { [weak self] (type) in
                self?.router.didSelect(type: type)
            })
            .disposed(by: disposeBag)
    }

}
