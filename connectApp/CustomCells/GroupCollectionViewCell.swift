//
//  GroupCollectionViewCell.swift
//  connectApp
//
//  Created by Ashish Dutt on 20/05/24.
//

import UIKit

protocol GroupCollectionViewCellDelegate {
    func didClickDeleteButton(indexPath: IndexPath)
}

class GroupCollectionViewCell: UICollectionViewCell {
    
    var delegate: GroupCollectionViewCellDelegate?
    var indexPath: IndexPath!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func generateCell(for fUser: FUser, at indexPath: IndexPath) {
        self.indexPath = indexPath
        nameLabel.text = fUser.fullName
        
        if fUser.avatar != "" {
            imageFromData(imageData: fUser.avatar) { avatarImage in
                self.userImageView.image = avatarImage!.circleMasked
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        delegate?.didClickDeleteButton(indexPath: indexPath)
    }
    
}
