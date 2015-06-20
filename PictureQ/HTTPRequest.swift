
import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = HTTPRequest()

let THEME_BLUE = UIColor(red:0.14, green:0.32, blue:0.46, alpha:1)
let BURNT_ORANGE = UIColor(red:0.98, green:0.5, blue:0.27, alpha:1)
let RICE_FLOWER = UIColor(red:0.95, green:1, blue:0.9, alpha:1)

let API_URL = "http://tiyqpic.herokuapp.com"

class HTTPRequest: NSObject {
    
    //when accessed this will be railsrequest.session - singleton class
    class func session() -> HTTPRequest { return _singleton }
    
    //add id property
    
    var token: String? {
        
        get {
            //return the value of the token when this is called
            return defaults.objectForKey("TOKEN") as? String
            
        }
        
        set {
            
            //sets a new token value
            defaults.setValue(newValue, forKey: "TOKEN")
            //gets saved into NSDefaults
            defaults.synchronize()
            
        }
        
    }
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    var getDataFromRailsArray: [AnyObject] = []
    
    func registerwithCompletion(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/users/register",
            "parameters" : [
                
                "userName" : username,
                "email" : email,
                "password" : password
                
            ]
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                completion()
                
            }
            
        })
        
    }
    
    func loginWithCompletion(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/users/login",
            "parameters" : [
            
            "username" : username,
            "password" : password
            
            ]
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)

            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                completion()
                
            }
            
        })
        
    }
    
    func postImage() {
        
        
        
    }
    
    func getImages(completion: () -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/posts",
            
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo) // array of post dictionaries
            
            if let dataFromRailsRequest = responseInfo as? [AnyObject] {
                
                self.getDataFromRailsArray = dataFromRailsRequest
                
                completion()
                
            }
            
        })
        
    }
    
    //we make the completion optional nil if it doesn't complete
    func requestWithInfo(info: [String:AnyObject], andCompletion completion: ((responseInfo: AnyObject?) -> Void)?) {
        
        let endpoint = info["endpoint"] as! String
        
        if let url = NSURL(string: API_URL + endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            //NSMutableURLRequest is needed to with HTTPMethod
            request.HTTPMethod = info["method"] as! String
            
            if let token = token {
                
                request.setValue(token, forHTTPHeaderField: "Access_Token")
                
            }
            
            //////// BODY (only run this code if HTTPMethod != "GET"
            
            if let bodyInfo = info["parameters"] as? [String:AnyObject] {
            
                let requestData = NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions.allZeros, error: nil)
                
                let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
                
                let postLength = "\(jsonString!.length)"
                
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                
                let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.HTTPBody = postData
            
            }
            
            //////// BODY
            
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                println("test 1 \(response)")
                println(data)
                println(error)
                
                //dictionary that comes back
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                    
                    //safe optional in case no data comes back
                    //responseInfo completion block is a function being run above
                    completion?(responseInfo: json)
                    
                }
                
            })
            
        }
        
        
    }
    
    
}
