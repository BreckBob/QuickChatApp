//
//  WelcomeViewController.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/21/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var backendless = Backendless.sharedInstance()
    var currentUser: BackendlessUser?

    override func viewWillAppear(animated: Bool) {
        
        backendless.userService.setStayLoggedIn(true)
        
        self.currentUser = backendless.userService.currentUser
        
        if self.currentUser != nil {
            //here segue to recents vc
            
            dispatch_async(dispatch_get_main_queue()) {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
                vc.selectedIndex = 0
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
