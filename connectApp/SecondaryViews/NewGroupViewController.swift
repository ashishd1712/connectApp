//
//  NewGroupViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 16/05/24.
//

import UIKit
import ImagePicker

class NewGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GroupCollectionViewCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var memberIDs: [String] = []
    var allMembers: [FUser] = []
    var groupIcon: UIImage?
    var groupIconString: String = ""
    
    @IBOutlet weak var groupIconImageView: UIImageView!
    @IBOutlet weak var groupTitleTextField: UITextField!
    @IBOutlet weak var participantsCounterLabel: UILabel!
    @IBOutlet weak var editIconButton: UIButton!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateParticipantsCounterLabel()
    }
    
    private func updateParticipantsCounterLabel() {
        participantsCounterLabel.text = "Participants: \(allMembers.count)"
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createButtonPressed))]
        self.navigationItem.rightBarButtonItem?.isEnabled = allMembers.count > 0 && groupTitleTextField.text != ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = groupTitleTextField.text != ""
    }
    
    @objc func createButtonPressed(_ sender: Any) {
        if groupTitleTextField.text != "" {
            memberIDs.append(FUser.currentID())
            
            let avatarData = UIImage(systemName: "person.3.fill")!.jpegData(compressionQuality: 0.7)!
            var avatar = avatarData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            if groupCollectionView != nil {
                avatar = groupIconString
            }
            
            let groupID = UUID().uuidString
            let group = Group(groupID: groupID, subject: groupTitleTextField.text!, ownerID: FUser.currentID(), members: memberIDs, avatar: avatar)
            
            group.saveGroup()
            
            startGroupChat(group: group)
            
            
            let chatVC = ChatViewController()
             
            chatVC.titleName = group.groupDictionary[kNAME] as? String
            chatVC.memberIds = group.groupDictionary[kMEMBERS] as? [String]
            chatVC.membersToPush = group.groupDictionary[kMEMBERS] as? [String]
             
            chatVC.chatRoomId = groupID
            chatVC.isGroup = true
             
            chatVC.hidesBottomBarWhenPushed = true
             
            self.navigationController?.pushViewController(chatVC, animated: true)
             
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        showActionSheet()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.participantCell, for: indexPath) as! GroupCollectionViewCell
        
        cell.delegate = self
        cell.generateCell(for: allMembers[indexPath.row], at: indexPath)
        
        return cell
    }
    
    func didClickDeleteButton(indexPath: IndexPath) {
        allMembers.remove(at: indexPath.row)
        memberIDs.remove(at: indexPath.row)
        
        groupCollectionView.reloadData()
        updateParticipantsCounterLabel()
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count > 0 {
            self.groupIcon = images.first!
            self.groupIconImageView.image = self.groupIcon!.circleMasked
            self.editIconButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoImage = UIImage(systemName: "camera")
        let libraryImage = UIImage(systemName: "photo.badge.plus")
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(with: .camera)
            }
        }
        takePhoto.setValue(takePhotoImage, forKey: "image")
        
        let library = UIAlertAction(title: "Photo Library",style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
            }
        }
        library.setValue(libraryImage, forKey: "image")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(library)
        sheet.addAction(takePhoto)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func showPicker(with source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey(rawValue: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage
        
        groupIconString = ""
        
        self.groupIconImageView.image = image?.circleMasked
        
        let pictureData = image?.jpegData(compressionQuality: 0.4)!
        groupIconString = (pictureData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
