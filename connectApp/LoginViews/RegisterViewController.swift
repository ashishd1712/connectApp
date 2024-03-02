//
//  RegisterViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 03/03/24.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet var profileImageGestureRecogniser: UITapGestureRecognizer!
    
    var avatarString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileImageGestureRecogniser.addTarget(self, action: #selector(self.profileImageClicked))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageGestureRecogniser)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
       
    }
    
    private func setupUI() {
        cornerRadius(for: signUpButton)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func validateFields(name: String, email: String, password: String, phone: String, countryCode: String) -> Bool {
        if isValid(email: email) && isValid(phone: phone) && name != "" && countryCode != "" && password.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    @objc func profileImageClicked() {
        showActionSheet()
    }
    
    func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(library)
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
    
    private func getAvatar() -> String {
        if avatarString == "" {
            var avatarStr: String = ""
            imageFromInitials(name: nameTextField.text!) { (avatarTitle) in
                let avatarImg = avatarTitle.jpegData(compressionQuality: 0.7)
                avatarStr = avatarImg!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            }
            return avatarStr
        } else {
            return avatarString
        }
    }
    
}

extension RegisterViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage
        let picturePath = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.profileImageView.image = picturePath
        let pictureData = image?.jpegData(compressionQuality: 0.4)!
        avatarString = (pictureData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
        
        dismiss(animated: true, completion: nil)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
