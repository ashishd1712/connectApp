//
//  Util.swift
//  connectApp
//
//  Created by Ashish Dutt on 02/03/24.
//

import UIKit
import Foundation

func cornerRadius(for view: UIView) {
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
}

func isValid(email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    let result = test.evaluate(with: email)
    return result
}

func isValid(phone: String) -> Bool {
    let regex = "[0-9]{10,}"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    let result = test.evaluate(with: phone)
    return result
}

func showAlert(title: String, message: String, in vc: UIViewController) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(okButton)
    vc.present(alert, animated: true, completion: nil)
}

func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?) {
    
    let newVC = UIStoryboard(name: "main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    newVC.modalPresentationStyle = .fullScreen
    vc.present(newVC, animated: animated, completion: completion)
}

func imageFromInitials(name: String?, with: @escaping (_ image: UIImage) -> Void) {
    var string: String!
    var size = 36
    
    var delimiter = " "
    let token = name!.components(separatedBy: delimiter)
    let firstName = token[0]
    var lastName = ""
    if token.count > 1 {
        lastName = token[1]
    }
    if firstName != "" && lastName != "" {
        string = String(firstName.first!).uppercased() + String(lastName.first!).uppercased()
    } else {
        string = String(firstName.first!).uppercased()
        size = 72
    }
    
    let lblName = UILabel()
    lblName.frame.size = CGSize(width: 100, height: 100)
    lblName.textColor = .white
    lblName.font = UIFont(name: lblName.font.fontName, size: CGFloat(size))
    lblName.text = string
    lblName.textAlignment = .center
    lblName.backgroundColor = .lightGray
    lblName.layer.cornerRadius = 25
    
    UIGraphicsBeginImageContext(lblName.frame.size)
    lblName.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    with(image!)
}

private var dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
