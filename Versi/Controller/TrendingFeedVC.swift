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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let datasource = PublishSubject<[Repo]>()
    let bag = DisposeBag()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Cool Github Repos !!  😎", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorMessageWhenReposAreNotFoundAndRestore), name: NSNotification.Name.init(NOTIFY_WHEN_REPOS_IS_EMPTY), object: nil)
        fetchData()
        bindToRepoCell()
    }
    
    @objc func fetchData() {
        activityIndicator.startAnimating()
        DownloadService.instance.convertToTrendingReposArray { (repos) in
            self.datasource.onNext(repos)
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
        }
    }
    @objc func showErrorMessageWhenReposAreNotFoundAndRestore() {
        AppDelegate.topic = AppDelegate.previousTopic
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Error!", message: "Repos Not Found, Please try again", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    func bindToRepoCell() {
        datasource.bind(to: tableView.rx.items(cellIdentifier: "trendingRepoCell")) { (row, repo: Repo, cell: TrendingRepoCell) in
            // Set UI
            cell.configureCell(repo: repo)
            }.disposed(by: bag)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Topic : \(AppDelegate.topic)", message: "Please enter your favorite topic on Github", preferredStyle: .alert)
        alert.addTextField { (_ textField: UITextField) in
            textField.placeholder = AppDelegate.topic
        }
        let action = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
            if let text = alert.textFields![0].text, text != "" {
                AppDelegate.previousTopic = AppDelegate.topic
                AppDelegate.topic = text
                self.fetchData()
            }
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

