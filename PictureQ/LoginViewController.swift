//
//  LoginViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUserNameTextField: WelcomeTextField!
    @IBOutlet weak var loginPasswordTextField: WelcomeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //taps out of text field or hits return, dismisses keyboard
        let tapper = UITapGestureRecognizer(target: self.view, action:Selector("endEditing:"))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: { () -> Void in })
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if count(self.loginUserNameTextField.text) > 0 && count(self.loginPasswordTextField.text) > 0 {
        
            HTTPRequest.session().username = loginUserNameTextField.text
            HTTPRequest.session().password = loginPasswordTextField.text
            
            HTTPRequest.session().loginWithCompletion { () -> Void in
                
                if let feedTVC = self.storyboard?.instantiateViewControllerWithIdentifier("feedTVC") as? UINavigationController {
                    
                    self.presentViewController(feedTVC, animated: true, completion: nil)
                    
                    
                } else {
                    
                    println("This will go to alert screen")
                }

            
            }
        
        
        }
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
