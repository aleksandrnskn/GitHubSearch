//
//  GHSDataStruct.swift
//  GitHubSearch
//
//  Created by Aleksandr Aniskin on 11.05.2021.
//

import Foundation

struct Repos: Decodable {
    
    let name: String
    var language: String?
    let html_url: String
    
}

struct searchResult: Decodable {
    
    let total_count: Int
    var items: [Repos]
    
}
