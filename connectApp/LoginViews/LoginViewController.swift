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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
    }
    
    private func setupUI() {
        cornerRadius(for: loginButton)
        cornerRadius(for: registerButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}
