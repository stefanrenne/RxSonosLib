//
//  QueueViewController.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib
import RxSwift

class QueueViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    internal var router: QueueRouter?
    @IBOutlet var queueLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupQueueTableViewItems()
        setupQueueCellTapHandling()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    private func setupQueueTableViewItems() {
        tableView.register(UINib(nibName: String(describing: QueueTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: QueueTableViewCell.identifier)
        
        SonosInteractor
            .getActiveGroup()
            .getQueue()
            .do(onNext: { [weak self] (tracks) in
                self?.queueLabel.text = "\(tracks.count) tracks"
            })
            .bind(to: tableView.rx.items(cellIdentifier: QueueTableViewCell.identifier, cellType: QueueTableViewCell.self)) { (_, track, cell) in
                cell.model = TrackViewModel(track: track)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupQueueCellTapHandling() { }

    @IBAction func shuffleAction(_ sender: UIButton) {
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        router?.close()
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
    }
    
    @IBAction func editAction(_ sender: UIButton) {
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
    }
}
