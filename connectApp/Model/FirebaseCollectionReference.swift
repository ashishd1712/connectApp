//
//  FirebaseCollectionReference.swift
//  connectApp
//
//  Created by Ashish Dutt on 04/03/24.
//

import Foundation
import FirebaseFirestore
import MessageUI
import CoreTelephony

enum FirebaseCollectionReference: String {
    case Message
    case RecentChat
    case User
    case Group
    case Call
    case Typing
}

func collectionReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
