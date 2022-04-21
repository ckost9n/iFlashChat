//
//  LoginViewController.swift
//  iFlashChat
//
//  Created by Konstantin on 20.04.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToChat", sender: nil)
    }

    
    // MARK: - Navigation



}
