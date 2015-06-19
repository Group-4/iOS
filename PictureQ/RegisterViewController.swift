//
//  RegisterViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var signupUserNameTextField: WelcomeTextField!
    @IBOutlet weak var signupEmailTextField: WelcomeTextField!
    @IBOutlet weak var signupPasswordTextField: WelcomeTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        if self.signupUserNameTextField.isFirstResponder() {
            self.signupUserNameTextField.resignFirstResponder()
        }
        
        if self.signupEmailTextField.isFirstResponder() {
            self.resignFirstResponder()
        }
        
        if self.signupPasswordTextField.isFirstResponder() {
            self.resignFirstResponder()
        }
        
        if count(self.signupUserNameTextField.text) > 0 && count(self.signupEmailTextField.text)  > 0 && count(self.signupPasswordTextField.text) > 0 {
            
                var postEndpoint: String = "http://tiyqpic.herokuapp.com/users/register"
                let request = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
                
                request.HTTPMethod = "POST"
                let userNamePost = signupUserNameTextField.text
                let emailPost = signupEmailTextField.text
                let passwordPost = signupPasswordTextField.text
                let registerUpString = NSString(format: "username=%@&email=%@&password=%@", userNamePost, emailPost, passwordPost)
                println(registerUpString)
                request.HTTPBody = registerUpString.dataUsingEncoding(NSUTF8StringEncoding)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    data, response, error in
                    
                    if error != nil {
                        println("error=\(error)")
                        return
                    }
                    
                    println("response = \(response)")
                    
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("responseString = \(responseString)")
                    
                    let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                    
                    if let accessToken = jsonResult?["access_token"] as? String {
                        
                        HTTPRequest.session().token = accessToken
                        println("This is a token: " + "\(HTTPRequest.session().token)")
                        
                    }
                    
                    println("this is json results " + "\(jsonResult)")
                
                }
                
                task.resume()
        
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


