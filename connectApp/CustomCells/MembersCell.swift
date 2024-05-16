//
//  MembersCell.swift
//  connectApp
//
//  Created by Ashish Dutt on 13/05/24.
//

import UIKit

class MembersCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCellFor(fUser: FUser, at indexPath: IndexPath) {
        self.indexPath = indexPath
        self.nameLabel.text = fUser.fullName
        
        if fUser.avatar != "" {
            imageFromData(imageData: fUser.avatar) { avatarImage in
                if avatarImage != nil {
                    self.userImageView.image = avatarImage!.circleMasked
                }
            }
        }
    }

}
