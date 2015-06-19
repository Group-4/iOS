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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        HTTPRequest.session().username = loginUserNameTextField.text
        HTTPRequest.session().password = loginPasswordTextField.text
        
        HTTPRequest.session().loginWithCompletion { () -> Void in
            
            if let feedTVC = self.storyboard?.instantiateViewControllerWithIdentifier("feedTVC") as? UINavigationController {
                
                self.presentViewController(feedTVC, animated: true, completion: nil)
                
            } else {
                
                println("This will go to alert screen")
            }

            
        }
        
//        var postEndpoint: String = "http://tiyqpic.herokuapp.com/users/login"
//        let request = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
//        
//        request.HTTPMethod = "POST"
//        let userNamePost = loginUserNameTextField.text
//        let passwordPost = loginPasswordTextField.text
//        
//        var loginInfo = [ "username" : "\(userNamePost)", "password" : "\(passwordPost)" ]
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(loginInfo, options: nil, error: &err)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("\(HTTPRequest.session().token)", forHTTPHeaderField: "Access_Token")
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                
//                return
//            }
//            
//            println("response = \(response)")
//            
//            let statusCode = (response as! NSHTTPURLResponse).statusCode
//            
//            println(statusCode)
//            
//            if statusCode == 200 {
//
//                    println("Hey moving to next screen")
//                
//                if let feedTVC = self.storyboard?.instantiateViewControllerWithIdentifier("feedTVC") as? UINavigationController {
//                    
//                    self.presentViewController(feedTVC, animated: true, completion: nil)
//                    
//                } else {
//                    
//                    println("This will go to alert screen")
//                }
//                
//            
//            }
//            
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//            
//            
//       }
//        
//        task.resume()
        
    }
    
    func connection(connection:NSURLConnection!, willSendRequestForAuthenticationChallenge challenge:NSURLAuthenticationChallenge!) {
        
        if challenge.previousFailureCount > 1 {
            
        } else {
            let creds = NSURLCredential(user: loginUserNameTextField.text, password: loginPasswordTextField.text, persistence: NSURLCredentialPersistence.None)
            
            challenge.sender.useCredential(creds, forAuthenticationChallenge: challenge)
            
        }
        
    }
    
    func connection(connection:NSURLConnection!, didReceiveResponse response: NSURLResponse) {
        let status = (response as? NSHTTPURLResponse)!.statusCode
        
        println("status code is \(status)")
        // 200? Yeah authentication was successful
        
        
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
