//
//  FUser.swift
//  connectApp
//
//  Created by Ashish Dutt on 04/03/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FUser {
    let objectID: String
    var email: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var countryCode: String
    var isOnline: Bool
    var contacts: [String]
    
    init(objectID: String, email: String, fullName: String, avatar: String, phoneNumber: String, countryCode: String) {
        self.objectID = objectID
        self.email = email
        self.fullName = fullName
        self.avatar = avatar
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.isOnline = true
        self.contacts = []
    }
    
    init(_dictionary: NSDictionary) {
        objectID = _dictionary[kOBJECTID] as! String
          
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        if let fname = _dictionary[kFULLNAME] {
            fullName = fname as! String
        } else {
            fullName = ""
        }
        if let avat = _dictionary[kAVATAR] {
            avatar = avat as! String
        } else {
            avatar = ""
        }
        if let onl = _dictionary[kISONLINE] {
            isOnline = onl as! Bool
        } else {
            isOnline = false
        }
        if let phone = _dictionary[kPHONE] {
            phoneNumber = phone as! String
        } else {
            phoneNumber = ""
        }
        if let countryC = _dictionary[kCOUNTRYCODE] {
            countryCode = countryC as! String
        } else {
            countryCode = ""
        }
        if let cont = _dictionary[kCONTACT] {
            contacts = cont as! [String]
        } else {
            contacts = []
        }
    }
    
    class func currentID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser () -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    class func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { firUser, error in
            if error != nil {
                completion(error)
                return
            } else {
                fetchCurrentUserFromFirestore(userID: firUser!.user.uid)
                completion(error)
            }
        }
    }
    
    class func registerUserWithEmail(email: String, password: String, fullName: String, avatar: String, phoneNumber: String, countryCode: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { firUser, error in
            if error != nil {
                completion(error)
                return
            }
            
            let fUser = FUser(objectID: firUser!.user.uid, email: firUser!.user.email!, fullName: fullName, avatar: avatar, phoneNumber: phoneNumber, countryCode: countryCode)
            saveUserLocally(fUser: fUser)
            saveUserToFirestore(fUser: fUser)
            completion(error)
        }
    }
    
    class func logoutCurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    class func deleteUser(completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            completion(error)
        })
    }
}

func saveUserToFirestore(fUser: FUser) {
    collectionReference(.User).document(fUser.objectID).setData(userDictionaryFrom(user: fUser) as! [String: Any]) { error in
        print("error is: \(error?.localizedDescription)")
    }
}
func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

func fetchCurrentUserFromFirestore(userID: String) {
    collectionReference(.User).document(userID).getDocument { snapshot, error in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
            UserDefaults.standard.setValue(snapshot.data() as! NSDictionary, forKeyPath: kCURRENTUSER)
            UserDefaults.standard.synchronize()
        }
    }
}

func fetchCurrentUserFromFirestore(userID: String, completion: @escaping (_ user: FUser?) -> Void) {
    collectionReference(.User).document(userID).getDocument { snapshot, error in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
            let user = FUser(_dictionary: snapshot.data()! as NSDictionary)
            completion(user)
        } else {
            completion(nil)
        }
    }
}

func userDictionaryFrom(user: FUser) -> NSDictionary {
    return NSDictionary(objects: [user.objectID, user.email, user.fullName, user.avatar, user.contacts, user.isOnline, user.phoneNumber, user.countryCode], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kCONTACT as NSCopying, kISONLINE as NSCopying, kPHONE as NSCopying, kCOUNTRYCODE as NSCopying])
}

func getUsersFromFirestore(withIds: [String], completion: @escaping (_ usersArray: [FUser]) -> Void) {
    var count = 0
    var usersArray: [FUser] = []
    
    for userId in withIds {
        collectionReference(.User).document(userId).getDocument { snapshot, error in
            guard let snapshot = snapshot else { return }
            if snapshot.exists {
                let user = FUser(_dictionary: snapshot.data()! as NSDictionary)
                count += 1
                
                if user.objectID != FUser.currentID() {
                    usersArray.append(user)
                }
            } else {
                completion(usersArray)
            }
            if count == withIds.count {
                completion(usersArray)
            }
        }
    }
}

func updateCurrentUserInFireStore(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    guard let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) else { return }
    var tempWithValues = withValues
    let currentUserId = FUser.currentID()
    let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
    userObject.setValuesForKeys(tempWithValues)
    collectionReference(.User).document(currentUserId).updateData(withValues) { error in
        if error != nil {
            completion(error)
            return
        }
        
        UserDefaults.standard.setValue(userObject, forKeyPath: kCURRENTUSER)
        UserDefaults.standard.synchronize()
        completion(error)
    }
}
