//
//  LoginViewController.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/21/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    @IBAction func loginBarButtonItemPressed(sender: AnyObject) {
        
        if self.emailTextField.text != "" && self.passwordTextField.text != "" {
            
            ProgressHUD.show("Logging in...")
            
            self.email = self.emailTextField.text
            self.password = self.passwordTextField.text
            
            //login new user
            self.loginUser(email!, password: password!)
            
        }
        else {
            //Warning to user
            ProgressHUD.showError("All fields are required")
        }
        
    }
    
    func loginUser (email: String, password: String) {
        
        self.backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            
            ProgressHUD.dismiss()
            
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            //here segue to recents vc
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            vc.selectedIndex = 0
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }) { (fault : Fault!) in
            print("Server reported and error: \(fault)")
        }
        
    }

}
