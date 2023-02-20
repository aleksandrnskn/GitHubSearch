//
//  GHSViewController.swift
//  GitHubSearch
//
//  Created by Aleksandr Aniskin on 11.05.2021.
//

import UIKit
import WebKit

class GHSViewController: UIViewController {

    @IBOutlet weak var UsersOrReposSearch: UISegmentedControl!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ReposTableView: UITableView!
    @IBOutlet weak var WebNavigationBar: UINavigationBar!
    @IBOutlet weak var SearchResultWebView: WKWebView!
    @IBOutlet weak var WebNavigationBarTitle: UINavigationItem!
    
    var userName: String!
    var reposName: String!
    
    var reposData: [Repos] = []
    var searchData: searchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Search Button
    @IBAction func PressSearch(_ sender: Any) {
        switch UsersOrReposSearch.selectedSegmentIndex {
        case 0:
            print("User Search")
            userName = SearchTextField.text!
            self.SearchTextField.text = ""
            if userName != "" {
                GHSDataLoader().loadUserRepos(userName) {
                    reposData in
                    self.reposData = reposData
                    self.ReposTableView.reloadData()
                }
            } else {
                SearchTextField.placeholder = "Enter corect User name"
            }
        case 1:
            print("Repos Search")
            reposName = SearchTextField.text!
            self.SearchTextField.text = ""
            if reposName != "" {
                GHSDataLoader().loadSearchRepos(reposName) {
                    searchData in
                    self.searchData = searchData
                    self.ReposTableView.reloadData()
                }
            } else {
                SearchTextField.placeholder = "Enter corect name of repositoriy"
            }
        default:
            return
        }
        view.endEditing(true)
    }
    
    // MARK: SegmentedControl
    @IBAction func userOrRepos(_ sender: Any) {
        switch UsersOrReposSearch.selectedSegmentIndex {
            case 0:
                print("User")
                self.SearchTextField.text = ""
                self.SearchTextField.placeholder = "Enter user name"
                self.ReposTableView.reloadData()
            case 1:
                print("Repos")
                self.SearchTextField.text = ""
                self.SearchTextField.placeholder = "Enter name of repositoriy"
                self.ReposTableView.reloadData()
            default:
                return
        }
        view.endEditing(true)
    }
    
    // Close WebView
    @IBAction func backButton(_ sender: Any) {
        SearchResultWebView.isHidden = true
        WebNavigationBar.isHidden = true
    }
    
    
}

// MARK: TableView Data Source
extension GHSViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch UsersOrReposSearch.selectedSegmentIndex {
            case 0:
                return reposData.count
            case 1:
                if searchData != nil {
                    return searchData.items.count
                }
                return 0
            default:
                return 0
        }
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reposCell", for: indexPath) as! GHSReposTableViewCell
        
        switch UsersOrReposSearch.selectedSegmentIndex {
            case 0:
                cell.reposNameLabel.text = reposData[indexPath.row].name
                cell.languageLabel.text = reposData[indexPath.row].language
            case 1:
                cell.reposNameLabel.text = searchData.items[indexPath.row].name
                cell.languageLabel.text = searchData.items[indexPath.row].language
            default:
                return cell
        }
        return cell
    }
    
    // MARK: Show WebView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch UsersOrReposSearch.selectedSegmentIndex {
            case 0:
                guard let url = URL(string: reposData[indexPath.row].html_url) else {
                    return
                }
                print(url)
                SearchResultWebView.load(URLRequest(url: url))
                SearchResultWebView.isHidden = false
                WebNavigationBar.isHidden = false
                WebNavigationBarTitle.title = reposData[indexPath.row].name
            case 1:
                guard let url = URL(string: searchData.items[indexPath.row].html_url) else {
                    return
                }
                print(url)
                SearchResultWebView.load(URLRequest(url: url))
                SearchResultWebView.isHidden = false
                WebNavigationBar.isHidden = false
                WebNavigationBarTitle.title = searchData.items[indexPath.row].name
            default:
                return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Create URL
extension GHSViewController {
    public func createUrlForUserData(forUserName userName: String) -> String {
        guard let urlString = "https://api.github.com/users/\(userName)/repos".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "Somthing wrong" }
        return urlString
    }
    
    public func createUrlForReposData(forReposName reposName: String) -> String {
        guard let urlString = "https://api.github.com/search/repositories?q=\(reposName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "Somthing wrong" }
        return urlString
    }
}
