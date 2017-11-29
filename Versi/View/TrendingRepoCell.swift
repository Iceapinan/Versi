//
//  TrendingRepoCell.swift
//  Versi
//
//  Created by IceApinan on 15/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingRepoCell: UITableViewCell {
    
    
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var numberOfForksLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewReadMeButton: RoundedBorderButton!
    
    private var repoURL: String?
    let bag = DisposeBag()
    
    func configureCell(repo: Repo) {
        repoImageView.image = repo.image
        repoNameLabel.text = repo.name
        repoDescriptionLabel.text = repo.description
        numberOfForksLabel.text = String(describing: repo.numberOfForks)
        languageLabel.text = repo.language
        contributorsLabel.text = String(describing: repo.numberOfContributors)
        repoURL = repo.repoURL
        viewReadMeButton.rx.tap.subscribe(onNext: {
            self.window?.rootViewController?.presentSFViewController(from: self.repoURL!)
        }).disposed(by: bag)
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 15
        backView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
