
import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = HTTPRequest()

let THEME_BLUE = UIColor(red:0.14, green:0.33, blue:0.46, alpha:1)
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
    
    var intValueForAnswer = 0
    
    var getDataFromRailsArray: [AnyObject] = []
    var getDataForCurrentUser = 0
    
    var getDataForLeaderBoard: [AnyObject] = []
    var leaderBoardName: String = ""
    var leaderBoardScore = 0
    
    func logoutAndDeleteToken() {
        
        defaults.removeObjectForKey("TOKEN")
    }
    
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
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                completion()
                
            }
            
        })
        
    }
    
    func postGuess(guessID: Int, guessToSendToRails: String, completion: (correct: Bool) -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/posts/\(guessID)/guesses",
            
            "parameters" : [
                
                "guess" : "\(guessToSendToRails)",
                
            ]
            
            
            ] as [String:AnyObject]
        
        var intValueForAnswer: Int!
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            if let responseForGuess = responseInfo?["correct"] as? Int {
                
                let correct = Bool(responseForGuess)
                
                println(correct)
                
                println("response info for guesses " + "\(responseInfo)")
                
                self.intValueForAnswer = responseForGuess
                
                println(self.intValueForAnswer)
                
                completion(correct: correct)
                
            }
            
            
        })
                
    }
    
    func getCurrentUser(completion: () -> Void) {
    
        var info = [
    
            "method" : "GET",
            "endpoint" : "/users/current_user"
    
            ] as [String:AnyObject]
    
    
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in

            
            if let dataForCurrentUser = responseInfo?["points"] as? Int {
            
                self.getDataForCurrentUser = dataForCurrentUser
                
                println("this is current users score " + "\(dataForCurrentUser)")
            
                completion()
            
             }
            
        })

    }
    
    
    func getImages(completion: () -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/posts"
            /*
            
            query : [
                
                "page" : 1
                
            ]
            */
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            if let dataFromRailsRequest = responseInfo as? [AnyObject] {
                
                self.getDataFromRailsArray = dataFromRailsRequest
                
//                println(self.getDataFromRailsArray)
                
                completion()
                
            }
            
        })
        
    }
    
    func getLeaderBoard() {
        
        var info = [
        
            "method" : "GET",
            "endpoint" : "/leaderboard"
            
        ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            if let dataForLeadBoard = responseInfo as? [AnyObject] {
                
                self.getDataForLeaderBoard = dataForLeadBoard
                
            }

        })
    
        
    }
    
    //we make the completion optional nil if it doesn't complete
    func requestWithInfo(info: [String:AnyObject], andCompletion completion: ((responseInfo: AnyObject?) -> Void)?) {
        
        let endpoint = info["endpoint"] as! String
        
        //query parameters for GET request
        if let query = info["query"] as? [String:AnyObject] {
        
            var first = true
            
            for (key,value) in query {
                
                //choose sign if it is first ?(then) else :
                var sign = first ? "?" : "&"
                
//                endpoint += endpoint + "\(sign)\(key)=\(value)"
                
                //set first the first time it runs
                first = false
                
            }
        
        }
        
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
                
//                println("test 1 \(response)")
//                println(data)
//                println(error)
                
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
