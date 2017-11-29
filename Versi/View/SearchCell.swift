//
//  SearchCell.swift
//  Versi
//
//  Created by IceApinan on 29/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var numberOfForks: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var backView: UIView!
    public private(set) var repoURL : String?
    
    func configureCell(repo: Repo) {
        repoName.text = repo.name
        repoDescription.text = repo.description
        numberOfForks.text = String(describing: repo.numberOfForks)
        language.text = repo.language
        repoURL = repo.repoURL
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 15
        backView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

}
