//
//  Util.swift
//  connectApp
//
//  Created by Ashish Dutt on 02/03/24.
//

import UIKit
import Foundation
import FirebaseFirestore

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
    
    let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
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

func imageFromData(imageData: String, with: @escaping (_ image: UIImage?) -> Void) {
    var image: UIImage?
    let decodedData = NSData(base64Encoded: imageData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodedData! as Data)
    with(image)
}

func dataImageFromString(imageString: String, with: (_ image: Data?) -> Void) {
    let imageData = NSData(base64Encoded: imageString, options: NSData.Base64DecodingOptions(rawValue: 0))
    with(imageData as Data?)
}

func dictionaryFromSnapshot(snapshots: [DocumentSnapshot]) -> [NSDictionary] {
    var allMessages = [NSDictionary]()
    for snapshot in snapshots {
        allMessages.append(snapshot.data() as! NSDictionary)
    }
    return allMessages
}

func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "dd/MM/YYYY"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

extension UIImage {
    var isPortrait: Bool { return size.height > size.width }
    var isLandscape: Bool { return size.width > size.height }
    var breadth: CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize { return .init(width: breadth, height: breadth) }
    var breadthRect: CGRect { return .init(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    func scaleImageToSize(_ newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width / size.width
        let aspectHeight = newSize.height / size.height
        
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.width * aspectRatio
        
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
