//
//  WelcomeViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //checks for token, if found goes to login screen
        if HTTPRequest.session().token != nil {
            
            println(HTTPRequest.session().token)
            
            if let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as? UIViewController {
                
                println(loginViewController)
                
                self.presentViewController(loginViewController, animated: true, completion: nil)
                
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
