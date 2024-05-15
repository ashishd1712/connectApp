//
//  Constants.swift
//  connectApp
//
//  Created by Ashish Dutt on 04/03/24.
//

import Foundation
import UIKit

let userDefaults = UserDefaults.standard

//MARK: Notifications
public let USER_DID_LOGIN_NOTIFICATION = "UserDidLoginNotification"
public let APP_STARTED_NOTIFICATION = "AppStartedNotification"

// MARK: Firebase Headers
public let kUSER_PATH = "User"
public let kTYPINGPATH_PATH = "Typing"
public let kRECENT_PATH = "Recent"
public let kMESSAGE_PATH = "Message"
public let kGROUP_PATH = "Group"
public let kCALL_PATH = "Call"

// MARK: FUser
public let kOBJECTID = "objectId"
public let kEMAIL = "email"
public let kPHONE = "phone"
public let kCOUNTRYCODE = "countryCode"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let kCURRENTUSER  = "currentUser"
public let kISONLINE = "isOnline"
public let kVERIFICATIONCODE = "firebase_verification"
public let kFILEREFFERENCE = "gs://connectapp-ec7e3.appspot.com"

//
public let kBACKGROUBNDIMAGE = "backgroundImage"
public let kSHOWAVATAR = "showAvatar"
public let kPASSWORDPROTECT = "passwordProtect"
public let kFIRSTRUN = "firstRun"
public let kNUMBEROFMESSAGES = 10
public let kMAXDURATION = 120.0
public let kAUDIOMAXDURATION = 120.0
public let kSUCCESS = 2

// MARK: Recent
public let kCHATROOMID = "chatRoomId"
public let kUSERID = "userId"
public let kDATE = "date"
public let kPRIVATE = "private"
public let kGROUP = "group"
public let kGROUPID = "groupId"
public let kRECENTID = "recentId"
public let kMESSAGE = "message"
public let kMEMBERS = "members"
public let kMEMBERSTOPUSH = "membersToPush"
public let kDESCRIPTION = "description"
public let kLASTMESSAGE = "lastMessage"
public let kCOUNTER = "counter"
public let kTYPE = "type"
public let kWITHUSERUSERNAME = "withUserUserName"
public let kWITHUSERUSERID = "withUserUserId"
public let kOWNERID = "ownerId"
public let kSTATUS = "status"
public let kMESSAGEID = "messageId"
public let kNAME = "name"
public let kSENDERID = "senderId"
public let kSENDERNAME = "senderName"
public let kTHUMBNAIL = "thumbnail"
public let kISDELETED = "isDeleted"

// MARK: Contacts
public let kCONTACT = "contact"
public let kCONTACTID = "contactId"

// MARK: Message Types
public let kTEXT = "text"
public let kLOCATION = "location"
public let kPICTURE = "picture"
public let kVIDEO = "video"
public let kAUDIO = "audio"

// MARK: Coordinates
public let kLATITUDE = "latitude"
public let kLONGITUDE = "longitude"

// MARK: Message Status
public let kREAD = "read"
public let kDELIVERED = "delivered"
public let kDELETED = "deleted"
public let kREADDATE = "readDate"

// MARK: Push
public let kDEVICEID = "deviceId"

// MARK: Call
public let kCALLERID = "callerId"
public let kCALLERFULLNAME = "callerFullName"
public let kCALLSTATUS = "callStatus"
public let kCALLERAVATAR = "callerAvatar"
public let kWITHUSERFULLNAME = "withUserFullName"
public let kWITHUSERAVATAR = "withUserAvatar"
public let kISINCOMING = "isIncoming"


// MARK: Storyboard IDs
struct StoryboardID {
    static let membersViewController = "membersViewController"
    static let loginViewController = "loginViewController"
    static let registerViewController = "registerViewController"
    static let tabBarController = "tabBarController"
}
