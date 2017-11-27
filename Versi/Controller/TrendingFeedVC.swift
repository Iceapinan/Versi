//
//  TrendingFeedVC.swift
//  Versi
//
//  Created by IceApinan on 12/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class TrendingFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DownloadService.instance.convertToTrendingReposArray { (repos) in
            for item in repos {
                print(item.name)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trendingRepoCell", for: indexPath) as? TrendingRepoCell else {
            return UITableViewCell()
        }
        let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: "SWIFT", description: "Apple's programming language.", numberOfForks: 356, language: "Swift", numberOfContributors: 1234, repoURL: "www.apple.com")
        cell.configureCell(repo: repo)
        return cell
    }


}

