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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageCounterBackground.layer.cornerRadius = messageCounterBackground.frame.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
