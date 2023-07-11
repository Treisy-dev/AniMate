//
//  LoginViewController.swift
//  AniMate
//
//  Created by Данил on 11.07.2023.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var onDismiss: ((Bool) -> Void)?
    
    let login: String = "admin"
    let password: String = "admin"
    
    var VC: UIViewController = UIViewController()
    
    @IBAction func registerNewUser(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
    }
    
    @IBAction func logInAction(_ sender: Any) {
        if loginTextField.text == login && passwordTextField.text == password{
            onDismiss?(true)
            var myBool = UserDefaults.standard.bool(forKey: "isAutorize")
            myBool = true
            UserDefaults.standard.set(myBool, forKey: "isAutorize")
            self.dismiss(animated: true)
        }
    }
}
