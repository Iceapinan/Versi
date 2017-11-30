//
//  SearchVC.swift
//  Versi
//
//  Created by IceApinan on 13/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: RoundedBorderTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        bindElements()
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    func bindElements() {
        let searchResultsObservable = searchField.rx.text
            .orEmpty
            .debounce(1.0, scheduler: MainScheduler.instance)
            .map {
                $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            }
            .flatMap { (query) -> Observable<[Repo]> in
                if query == "" {
                    return Observable<[Repo]>.just([])
                } else {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    let url = searchURL + query + starsDescendingSegment
                    var searchRepos = [Repo]()
                    return URLSession.shared.rx.json(url: URL(string: url)!).map {
                        let results = $0 as AnyObject
                        let items = results.object(forKey: "items") as? [Dictionary<String,Any>] ?? []
                        for item in items {
                            guard let name = item["name"] as? String,
                                let description = item["description"] as? String,
                                let numberOfForks = item["forks_count"] as? Int,
                                let language = item["language"] as? String,
                                let repoURL = item["html_url"] as? String
                                else { break }
                            
                            // -1 in numberOfContributors means I don't care
                            let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: -1, repoURL: repoURL)
                            searchRepos.append(repo)
                        }
                        return searchRepos
                    }
                }
            }.observeOn(MainScheduler.instance)
        searchResultsObservable.bind(to: tableView.rx.items(cellIdentifier: "searchCell")) { (row, repo: Repo, cell: SearchCell) in
            cell.configureCell(repo: repo)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }.disposed(by: bag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchCell else { return }
            presentSFViewController(from: cell.repoURL!)
            cell.isSelected = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(!false)
        return !false
    }

}
