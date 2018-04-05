//
//  GroupsViewController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSonosLib

class GroupsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let getGroupsInteractor: GetGroupsInteractor = SonosInteractor.provideGroupsInteractor()
    internal var router: GroupsRouter?

    @IBOutlet var table: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        
        self.setupTableViewItems()
        self.setupCellTapHandling()
        self.startLoading()
    }
    
    func setupTableViewItems() {
        table.register(UINib(nibName: String(describing: GroupsTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: GroupsTableViewCell.identifier)
        
        print("groups: loading")
        getGroupsInteractor
            .get()
            .do(onNext: { [weak self] (_) in
                self?.stopLoading()
                print("groups: onNext")
            }, onError: { [weak self] (error) in
                self?.stopLoading()
                print("groups: \(error.localizedDescription)")
            }, onCompleted: { [weak self] in
                self?.stopLoading()
                print("groups: onCompleted")
            })
            .bind(to: table.rx.items(cellIdentifier: GroupsTableViewCell.identifier, cellType: GroupsTableViewCell.self)) { (row, group, cell) in
                cell.model = GroupViewModel(group: group)
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        table
            .rx
            .modelSelected(Group.self)
            .subscribe(onNext: { [weak self] (group) in
                self?.router?.continueToGroup(group)
            })
            .disposed(by: self.disposeBag)
    }
    
}

fileprivate extension GroupsViewController {
    func startLoading() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func stopLoading() {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}
