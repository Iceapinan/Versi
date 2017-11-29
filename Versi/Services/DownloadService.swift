//
//  DownloadService.swift
//  Versi
//
//  Created by IceApinan on 15/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class DownloadService {
    static let instance = DownloadService()
    func downloadTrendingReposDictArray(completion: @escaping (_ reposDictArray: [Dictionary<String,Any>], _ count: Int) -> ()) {
        var trendingReposArray = [Dictionary<String,Any>]()
        Alamofire.request(trendingRepoURL).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String,Any> else { return }
            guard let repoDictArray = json["items"] as? [Dictionary<String,Any>] else { return }
            for repoDict in repoDictArray {
                if trendingReposArray.count <= 9 {
                    guard let name = repoDict["name"] as? String, let description = repoDict["description"] as? String, let numberOfForks = repoDict["forks_count"] as? Int, let language = repoDict["language"] as? String, let repoURL = repoDict["html_url"] as? String, let contributorsURL = repoDict["contributors_url"] as? String, let ownerDict = repoDict["owner"] as? Dictionary<String,Any>, let avatarURL = ownerDict["avatar_url"] as? String
                        else { break }
                    let repoDictionary : Dictionary<String,Any> = ["name" : name, "description" : description, "forks_count": numberOfForks, "language" : language, "html_url" : repoURL, "contributors_url" : contributorsURL, "avatar_url" : avatarURL]
                    trendingReposArray.append(repoDictionary)
                } else {
                    break
                }
            }
            completion(trendingReposArray, trendingReposArray.count)
            print(trendingReposArray.count)
        }
    }
    
    private func convertToTrendingRepo(dictionary dict: Dictionary<String,Any>, completion: @escaping (_ repo: Repo) -> ()) {
        let avatarURL = dict["avatar_url"] as! String
        let contributorsURL = dict["contributors_url"] as! String
        let name = dict["name"] as! String
        let description = dict["description"] as! String
        let numberOfForks = dict["forks_count"] as! Int
        let language = dict["language"] as! String
        let repoURL =  dict["html_url"] as! String
        
        self.downloadImageFor(avatarURL: avatarURL) { (returnedImage) in
            self.downloadContributorsDataFor(contributorsURL: contributorsURL, completion: { (contributors) in
                let repo = Repo(image: returnedImage, name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: contributors, repoURL: repoURL)
                completion(repo)
            })
        }
    }
    
    
    func convertToTrendingReposArray(completion: @escaping (_ reposArray: [Repo]) -> ())
    {
        var repos = [Repo]()
        self.downloadTrendingReposDictArray { (trendingReposDictArray, count) in
            for dict in trendingReposDictArray {
                self.convertToTrendingRepo(dictionary: dict, completion: { (repo) in
                    repos.append(repo)
                    guard (repos.count < count) else {
                       let sortedRepos = repos.sorted(by: { (repoA, repoB) -> Bool in
                            if repoA.numberOfForks > repoB.numberOfForks {
                                return true
                            } else {
                                return false
                            }
                        })
                        completion(sortedRepos)
                        return
                    }
                })
            }
        }
    }
    func downloadImageFor(avatarURL: String, completion: @escaping (_ image : UIImage) -> ()) {
        Alamofire.request(avatarURL).responseImage { (response) in
            guard let image = response.result.value else {
                return
            }
            completion(image)
        }
    }
    
    func downloadContributorsDataFor(contributorsURL: String, completion: @escaping (_ contributorsCount: Int) -> ()) {
        Alamofire.request(contributorsURL).responseJSON { (response) in
            guard let json = response.result.value as? [Dictionary<String, Any>] else { return }
            if !json.isEmpty {
                let contributors = json.count
                completion(contributors)
            }
        }
    }
    
}
