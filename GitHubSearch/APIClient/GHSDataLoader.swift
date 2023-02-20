//
//  GHSDataLoader.swift
//  GitHubSearch
//
//  Created by Aleksandr Aniskin on 11.05.2021.
//

import Foundation

class GHSDataLoader {
    
    func loadUserRepos(_ userName: String, completion: @escaping ([Repos]) -> Void) {
        
        let urlString = GHSViewController().createUrlForUserData(forUserName: userName)
        print(userName)
        print(urlString)
        let urlGitHub = URL(string: urlString)!
        let requestGitHub = URLRequest(url: urlGitHub)
        let session = URLSession.shared
    
        let taskGitHub = session.dataTask(with: requestGitHub) { data, response, error in
           
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let _ = json as? NSArray {
                DispatchQueue.main.async {
                    var userData: [Repos]!
                    
                    do {
                        let data = try JSONDecoder().decode([Repos].self, from: data)
                        userData = data
                        
                        for index in 0...userData.count-1 {
                            if userData[index].language == nil { 
                                userData[index].language = "---"
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    completion(userData)
                }
            }
        }
        taskGitHub.resume()
    }
    
    func loadSearchRepos(_ reposName: String, completion: @escaping (searchResult) -> Void) {
        
        let urlString = GHSViewController().createUrlForReposData(forReposName: reposName)
        print(reposName)
        print(urlString)
        let urlGitHub = URL(string: urlString)!
        let requestGitHub = URLRequest(url: urlGitHub)
        let session = URLSession.shared
    
        let taskGitHub = session.dataTask(with: requestGitHub) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let _ = json as? NSDictionary {
                DispatchQueue.main.async {
                    var searchData: searchResult!
                    
                    do {
                        let data = try JSONDecoder().decode(searchResult.self, from: data)
                        searchData = data
                        
                        if !(searchData.items.isEmpty) {
                            for index in 0...searchData.items.count-1 {
                                if searchData.items[index].language == nil {
                                    searchData.items[index].language = "---"
                                }
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    completion(searchData)
                }
            }
        }
        taskGitHub.resume()
    }
}

