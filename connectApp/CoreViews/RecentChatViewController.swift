//
//  RecentChatViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import UIKit
import FirebaseFirestore

class RecentChatViewController: UIViewController {
    
    var recentChats: [NSDictionary] = []
    var avatars = [UIImage]()
    var recentListener: ListenerRegistration!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChats()
        let view = UIView()
        self.tableView.tableFooterView = view
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    
    @IBAction func newChatButtonClicked(_ sender: Any) {
        instantiateViewController(identifier: StoryboardID.membersViewController, animated: true, by: self, completion: nil)
    }
    
    func loadChats() {
        recentListener = collectionReference(.RecentChat).whereField(kUSERID, isEqualTo: FUser.currentID()).addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            self.recentChats = []
            
            if !snapshot.isEmpty {
                let sorted = (dictionaryFromSnapshot(snapshots: snapshot.documents) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)]) as! [NSDictionary]
                
                for recent in sorted {
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        self.recentChats.append(recent)
                    }
                    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: recent[kCHATROOMID] as! String).getDocuments { snapshot, error in
                        
                    }
                }
                
                self.tableView.reloadData()
            }
        })
    }

}
