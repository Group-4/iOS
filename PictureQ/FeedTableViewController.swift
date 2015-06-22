//
//  FeedTableViewController.swift
//  PictureQ
//
//  Created by jpk on 6/19/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    var dataFromRails: [AnyObject] = []
    var imageToGuessScreen: UIImage?
    var nameToGuessScreen: String?
    var solvedToGuessScreen: String?
    
    var loginUserData = LoginViewController()
    
    @IBOutlet weak var usernameLoggedInLabel: UILabel!
    @IBOutlet weak var userCurrentScoreLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        
        //navigationbar
        navigationController?.navigationBar.barTintColor = THEME_BLUE
        
        //titlebar image - centered
        let titleBarImageView = UIImageView(frame: CGRectMake(0, 0, 60, 40))
        titleBarImageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "qpic_logo")
        titleBarImageView.image = image
        navigationItem.titleView = titleBarImageView
        
        HTTPRequest.session().getCurrentUser { () -> Void in
            
            self.userCurrentScoreLabel.text = "Points: \(String(HTTPRequest.session().getDataForCurrentUser))"
            
        }
        
        HTTPRequest.session().getLeaderBoard()

        
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTTPRequest.session().getImages { () -> Void in
            
            self.dataFromRails = HTTPRequest.session().getDataFromRailsArray
            self.tableView.reloadData()
            
        }
        
        usernameLoggedInLabel.text = HTTPRequest.session().username
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        HTTPRequest.session().logoutAndDeleteToken()
        
        if let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as? UIViewController {

            self.presentViewController(loginViewController, animated: true, completion: nil)
        
        }
        
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return dataFromRails.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        if let imageURL = dataFromRails[indexPath.row]["image_url"] as? String {
            
            //println(imageURL)
            
            if let url = NSURL(string: imageURL) {
                    
                if let imageData = NSData(contentsOfURL: url) {
                    
                    let image = UIImage(data: imageData)
                    
                    cell.imageFromRails.image = image
                    
                    //println(image)
                    
                }
            
            }
            
        }
        
        if let userNameFromRails = dataFromRails[indexPath.row]["owner"] as? String {
            
            cell.userNameForCell.text = userNameFromRails
            
        }
        
        if let solvedFromRails = dataFromRails[indexPath.row]["solved_by"] as? String {
            
            println("solved by " + "\(solvedFromRails)")
            
            if solvedFromRails != NSNull() {
            
                cell.solvedForCell.text = "Solved by " + "\(solvedFromRails)"
    
            } else {
                
                cell.solvedForCell.text = "Unsolved!"
                println("this line of code doesn't print")
                
            }
            
        }
        
        
        if let answerFromRails = dataFromRails[indexPath.row]["answer"] as? String {
        
            println("This is the answer " + "\(answerFromRails)")
            
        }
        
        return cell
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("guessSegue", sender: indexPath);

        let row = self.tableView.indexPathForSelectedRow()!.row
        println("row \(row) was selected")
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "guessSegue") {
            
            if let guessVC: GuessViewController = segue.destinationViewController as? GuessViewController {
            
                let row = (sender as! NSIndexPath).row
                
                let imageURLString = dataFromRails[row]["image_url"] as! String
                
                let imageURL = NSURL(string: imageURLString)
                
                let imageData = NSData(contentsOfURL: imageURL!)
                
                let imageSelected = UIImage(data: imageData!)
                
                self.imageToGuessScreen = imageSelected!
                
                guessVC.imageToGuessScreen = imageToGuessScreen
                
                let userNameFromRails = dataFromRails[row]["owner"] as? String
                
                guessVC.nameToGuessScreen = userNameFromRails
                
                if let solvedFromRails = dataFromRails[row]["solved"] as? NSNull {
                    
                    if solvedFromRails == NSNull() {
                        
                        guessVC.solvedToGuessScreen = "Unsolved!"
                        
                    } else {
                        
                        guessVC.solvedToGuessScreen = "Solved!"
                        
                    }
                    
                }
                
                let imageDataID = dataFromRails[row]["id"] as? Int
                
                guessVC.solvedToGuessID = imageDataID
                
                println("Next Screen")
                
            }
            
        }
        
    }

}
