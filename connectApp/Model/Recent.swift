//
//  Recent.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import Foundation

func createRecent(members: [String], chatRoomID: String, withUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    
    var tempMembers = members
    
    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: chatRoomID).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                
                if let currentUserID = currentRecent[kUSERID] {
                    
                    if tempMembers.contains(currentUserID as! String) {
                        tempMembers.remove(at: tempMembers.firstIndex(of: currentUserID as! String)!)
                    }
                }
            }
        }
        
        for userID in tempMembers {
            createRecentItem(userID: userID, chatRoomID: chatRoomID, members: members, withUserName: withUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
        }
        
    }
}

func createRecentItem(userID: String, chatRoomID: String, members: [String], withUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    let localReference = collectionReference(.RecentChat).document()
    let recentID = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    
    var recent: [String: Any]!
    
    if avatarOfGroup != nil {
        recent = [kRECENTID: recentID, kUSERID: userID, kCHATROOMID: chatRoomID, kMEMBERS: members, kMEMBERSTOPUSH: members, kWITHUSERFULLNAME: withUserName, kLASTMESSAGE : "", kCOUNTER: 0, kDATE: date, kTYPE: type, kAVATAR: avatarOfGroup!] as [String: Any]
    }
    
    localReference.setData(recent)
}

func startGroupChat(group: Group) {
    let chatRoomID = group.groupDictionary[kGROUPID] as! String
    let members = group.groupDictionary[kMEMBERS] as! [String]
    
    createRecent(members: members, chatRoomID: chatRoomID, withUserName: group.groupDictionary[kNAME] as! String, type: kGROUP, users: nil, avatarOfGroup: group.groupDictionary[kAVATAR] as? String)
}

func createRecentsForNewMembers(groupID: String, groupName: String, membersToPush: [String], avatar: String) {
    createRecent(members: membersToPush, chatRoomID: groupID, withUserName: groupName, type: kGROUP, users: nil, avatarOfGroup: avatar)
}

// MARK: Restart Recent Chat
func restartRecentChar(recent: NSDictionary) {
//    if recent[kTYPE] as! String == kPRIVATE {
//        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomID: recent[kCHATROOMID] as! String, withUserName: FUser.currentUser()!.fullName, type: kPRIVATE, users: [FUser.currentUser()!], avatarOfGroup: nil)
//    }
//    
//    if recent[kTYPE] as! String == kGROUP {
//
//    }
    
    createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomID: recent[kCHATROOMID] as! String, withUserName: recent[kWITHUSERFULLNAME] as! String, type: kGROUP, users: nil, avatarOfGroup: recent[kAVATAR] as? String)
}

// MARK: Update Recents

func updateRecents(chatRoomID: String, lastMessage: String) {
    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: chatRoomID).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
        
                updateRecentItem(recent: currentRecent, lastMessage: lastMessage)
            }
        }
    }
}

func updateRecentItem(recent: NSDictionary, lastMessage: String) {
    let date = dateFormatter().string(from: Date())
    
    var counter = recent[kCOUNTER] as! Int
    
    if recent[kUSERID] as? String != FUser.currentID() {
        counter += 1
    }
    
    let values = [kLASTMESSAGE: lastMessage, kCOUNTER: counter, kDATE: date] as [String: Any]
    
    collectionReference(.RecentChat).document(recent[kRECENTID] as! String).updateData(values)
}

// MARK: Delete recent

func deleteRecentChat(recentChatDictionary: NSDictionary) {
    if let recentID = recentChatDictionary[kRECENTID] {
        collectionReference(.RecentChat).document(recentID as! String).delete()
    }
}

// MARK: Clear Counter

func clearRecentCounter(chatRoomID: String) {
    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: chatRoomID).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                
                if currentRecent[kUSERID] as? String == FUser.currentID() {
                    clearRecentCounterItem(recent: currentRecent)
                }
            }
        }
    }
}

func clearRecentCounterItem(recent: NSDictionary) {
    collectionReference(.RecentChat).document(recent[kRECENTID] as! String).updateData([kCOUNTER: 0])
}

// MARK: Group

public func updateExistingRecentWithNewValues(chatRoomID: String, members: [String], withValues: [String: Any]) {
    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: chatRoomID).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let recent = recent.data() as NSDictionary
                
                updateRecent(recentID: recent[kRECENTID] as! String, withValues: withValues)
            }
        }
    }
}

func updateRecent(recentID: String, withValues: [String: Any]) {
    collectionReference(.RecentChat).document(recentID).updateData(withValues)
}

func blockUser(userToBlock: FUser) {
    let userID1 = FUser.currentID()
    let userID2 = userToBlock.objectID
    
    var chatRoomID = ""
    
    let value = userID1.compare(userID2).rawValue
    
    if value < 0 {
        chatRoomID = userID1 + userID2
    } else {
        chatRoomID = userID2 + userID1
    }
    
    getRecentsFor(chatRoomID: chatRoomID)
    
}

func getRecentsFor(chatRoomID: String) {
    collectionReference(.RecentChat).whereField(kCHATROOMID, isEqualTo: chatRoomID).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let recent = recent.data() as NSDictionary
                
                deleteRecentChat(recentChatDictionary: recent)
            }
        }
    }
}
