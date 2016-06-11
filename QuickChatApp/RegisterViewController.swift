//
//  RegisterViewController.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/21/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var email: String?
    var username: String?
    var password: String?
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newUser = BackendlessUser()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        if self.emailTextField.text != "" && self.usernameTextField.text != "" && self.passwordTextField.text != "" {
            
            ProgressHUD.show("Registering...")
            
            self.email = self.emailTextField.text
            self.username = self.usernameTextField.text
            self.password = self.passwordTextField.text
            
            self.regsiter(self.email!, username: self.username!, password: self.password!, avatarImage: self.avatarImage)
        }
        else {
            //Warning to user
            ProgressHUD.showError("All fields are required")
        }
    }
    
    //MARK: Backendless user registration
    
    func regsiter(email: String, username: String, password: String, avatarImage: UIImage?) {
        
        if avatarImage == nil {
            newUser!.setProperty("Avatar", object: "")
        }
        
        newUser!.email = email
        newUser!.name = username
        newUser!.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) in
            
            ProgressHUD.dismiss()
            
            //login new user
            self.loginUser(email, username: username, password: password)
            
            self.emailTextField.text = ""
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            
        }) { (fault : Fault!) in
            print("Server reported and error, couldn't register new user: \(fault)")
        }
        
    }

    func loginUser (email: String, username: String, password: String) {
        
        self.backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            vc.selectedIndex = 0
            
            self.presentViewController(vc, animated: true, completion: nil)
            
            
        }) { (fault : Fault!) in
            print("Server reported and error: \(fault)")
        }
        
    }
    
}
