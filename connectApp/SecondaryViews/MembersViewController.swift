//
//  MembersViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import UIKit
import FirebaseFirestore

class MembersViewController: UITableViewController, UISearchResultsUpdating {
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    var allUsersGroupped = NSDictionary() as! [String: [FUser]]
    var sectionTitleList: [String] = []
    
    var memberIDsOfGroupChat: [String] = []
    var membersOfGroupChat: [FUser] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Members"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressed))
        self.navigationItem.rightBarButtonItem = nextButton
        self.navigationItem.rightBarButtonItems?.first?.isEnabled = false
        loadMembers()
    }
    
    @objc func nextButtonPressed() {
        let newGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.newGroupViewController) as! NewGroupViewController
        
        newGroupVC.memberIDs = memberIDsOfGroupChat
        newGroupVC.allMembers = membersOfGroupChat
        
        self.navigationController?.pushViewController(newGroupVC, animated: true)
    }
    
    private func loadMembers() {
        var query = collectionReference(.User).order(by: kFULLNAME, descending: false)
        
        query.getDocuments { snapshot, error in
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroupped = [:]
            
            if error != nil {
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                for member in snapshot.documents {
                    let memberDictionary = member.data() as NSDictionary
                    let fUser = FUser(_dictionary: memberDictionary)
                    if fUser.objectID != FUser.currentID() {
                        self.allUsers.append(fUser)
                    }
                }
                self.splitDataIntoSections()
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate func splitDataIntoSections() {
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count {
            let currentUser = self.allUsers[i]
            let firstChar = currentUser.fullName.first!
            let firstCharString = "\(firstChar.uppercased())"
            
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.allUsersGroupped[sectionTitle] = []
                
                if !sectionTitleList.contains(sectionTitle) {
                    self.sectionTitleList.append(sectionTitle)
                }
            }
            self.allUsersGroupped[firstCharString]?.append(currentUser)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return allUsersGroupped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        } else {
            let sectionTitle = self.sectionTitleList[section]
            let users = self.allUsersGroupped[sectionTitle]
            return users!.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.memberCell, for: indexPath) as! MembersCell

        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUsersGroupped[sectionTitle]
            user = users![indexPath.row]
        }
        cell.generateCellFor(fUser: user, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUsersGroupped[sectionTitle]
            user = users![indexPath.row]
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! MembersCell
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        let selected = memberIDsOfGroupChat.contains(user.objectID)
        
        if selected {
            let objectIndex = memberIDsOfGroupChat.firstIndex(of: user.objectID)
            memberIDsOfGroupChat.remove(at: objectIndex!)
            membersOfGroupChat.remove(at: objectIndex!)
        } else {
            membersOfGroupChat.append(user)
            memberIDsOfGroupChat.append(user.objectID)
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = memberIDsOfGroupChat.count > 0
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        } else {
            return self.sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        } else {
            return self.sectionTitleList[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    // MARK: Searching
    func updateSearchResults(for searchController: UISearchController) {
        filterContactsForSearch(searchText: searchController.searchBar.text!)
    }
    
    private func filterContactsForSearch(searchText: String, scope: String = "All") {
        filteredUsers = allUsers.filter { (user) -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
