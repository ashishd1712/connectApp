//
//  RecentChatViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import UIKit
import FirebaseFirestore

class RecentChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recentChats: [NSDictionary] = []
    var avatars = [UIImage]()
    var recentListener: ListenerRegistration!
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        loadChats()
        let view = UIView()
        self.tableView.tableFooterView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    
    @IBAction func newChatButtonClicked(_ sender: Any) {
        let membersVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.membersViewController) as! MembersViewController
        self.navigationController?.pushViewController(membersVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.recentCell, for: indexPath) as! RecentCell
        
        let recent = recentChats[indexPath.row]
        
        cell.generateCell(recentChat: recent, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentChats.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let tempRecent = recentChats[indexPath.row]
        
        var muteTitle = "Unmute"
        var mute = false
        
        if (tempRecent[kMEMBERSTOPUSH] as! [String]).contains(FUser.currentID()) {
            muteTitle = "Mute"
            mute = true
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            self.recentChats.remove(at: indexPath.row)
            deleteRecentChat(recentChatDictionary: tempRecent)
            self.tableView.reloadData()
        }
        
        let muteAction = UITableViewRowAction(style: .default, title: muteTitle) { action, indexPath in
            
        }
        
        muteAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return [deleteAction, muteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent = recentChats[indexPath.row]
        restartRecentChat(recent: recent)
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.titleName = (recent[kWITHUSERFULLNAME] as? String)!
        chatVC.chatRoomId = (recent[kCHATROOMID] as? String)!
        chatVC.memberIds = (recent[kMEMBERS] as? [String])!
        chatVC.membersToPush = (recent[kMEMBERSTOPUSH] as? [String])!
        chatVC.isGroup = (recent[kTYPE] as? String) == kGROUP
        
        navigationController?.pushViewController(chatVC, animated: true)
    }

}
