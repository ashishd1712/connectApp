//
//  LoginViewController.swift
//  connectApp
//
//  Created by Ashish Dutt on 02/03/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if isValid(email: emailTextField.text!) && passwordTextField.text! != "" {
            performLogin()
        } else {
            showAlert(title: "Login Credentials Invalid", message: "Please enter registered account info.", in: self)
        }
     }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        instantiateViewController(identifier: "registerViewController", animated: true, by: self, completion: nil)
    }
    
    private func setupUI() {
        cornerRadius(for: loginButton)
        cornerRadius(for: registerButton)
    }
    
    private func performLogin() {
        FUser.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { error in
            if error != nil {
                showAlert(title: "Error", message: "Please enter correct login credentials", in: self)
            } else {
                self.goToTabBar()
            }
        }
    }
    
    private func goToTabBar() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentID()])
        instantiateViewController(identifier: "tabBarViewController", animated: true, by: self, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}
