//
//  RecentCell.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import UIKit

class RecentCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageCounterBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recentChatLabel: UILabel!
    @IBOutlet weak var unreadMessageCounter: UILabel!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageCounterBackground.layer.cornerRadius = messageCounterBackground.frame.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(recentChat: NSDictionary, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.nameLabel.text = recentChat[kWITHUSERFULLNAME] as? String
        let decryptedText = Encryption.decryptText(chatRoomId: recentChat[kCHATROOMID] as! String, encryptedMessage: recentChat[kLASTMESSAGE] as! String)
        
        self.recentChatLabel.text = decryptedText
        self.unreadMessageCounter.text = recentChat[kCOUNTER] as? String
        
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(imageData: avatarString as! String) { (avatarImage) in
                
                if avatarImage != nil {
                    self.userImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
        
        if recentChat[kCOUNTER] as! Int != 0 {
            
            self.unreadMessageCounter.text = "\(recentChat[kCOUNTER] as! Int)"
            self.messageCounterBackground.isHidden = false
            self.unreadMessageCounter.isHidden = false
        } else {
            self.messageCounterBackground.isHidden = true
            self.unreadMessageCounter.isHidden = true
        }
        
        var date: Date!
        
        if let created = recentChat[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        
        self.dateLabel.text = timeElapsed(date: date)
    }

}

