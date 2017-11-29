//
//  TrendingFeedVC.swift
//  Versi
//
//  Created by IceApinan on 12/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingFeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let datasource = PublishSubject<[Repo]>()
    let bag = DisposeBag()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Cool Github Repos !!  😎", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        fetchData()
        datasource.bind(to: tableView.rx.items(cellIdentifier: "trendingRepoCell")) { (row, repo: Repo, cell: TrendingRepoCell) in
            // Set UI
            cell.configureCell(repo: repo)
        }.disposed(by: bag)
    }
    
    @objc func fetchData() {
        DownloadService.instance.convertToTrendingReposArray { (repos) in
            self.datasource.onNext(repos)
            self.refreshControl.endRefreshing()
        }
    }
}

