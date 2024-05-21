//
//  Group.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import Foundation
import Firebase

class Group {
    
    let groupDictionary: NSMutableDictionary
    
    init(groupID: String, subject: String, ownerID: String, members: [String], avatar: String) {
        groupDictionary = NSMutableDictionary(objects: [groupID, subject, ownerID, members, avatar], forKeys: [kGROUPID as NSCopying, kNAME as NSCopying, kOWNERID as NSCopying, kMEMBERS as NSCopying, kAVATAR as NSCopying])
    }
    
    func saveGroup() {
        let date = dateFormatter().string(from: Date())
        groupDictionary[kDATE] = date
        collectionReference(.Group).document(groupDictionary[kGROUPID] as! String).setData(groupDictionary as! [String: Any])
    }
    
    class func updateGroup(groupID: String, withValues: [String: Any]) {
        collectionReference(.Group).document(groupID).updateData(withValues)
    }
    
}
