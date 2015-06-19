//
//  FeedTableViewController.swift
//  PictureQ
//
//  Created by jpk on 6/19/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    var allImages: [AnyObject] = []
    
    var imageToGuessScreen: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTTPRequest.session().getImages { () -> Void in
            
            self.allImages = HTTPRequest.session().getDataFromRailsArray
            self.tableView.reloadData()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return allImages.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        if let imageURL = allImages[indexPath.row]["image_url"] as? String {
            
            println(imageURL)
            
            if let url = NSURL(string: imageURL) {
                    
                if let imageData = NSData(contentsOfURL: url) {
                    
                    let image = UIImage(data: imageData)
                    
                    cell.imageFromRails.image = image
//                    self.imageToGuessScreen = image
                    
                    println(image)
                    
                }
            
            }
            
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
                
                println(allImages)
                
                let imageURLString = allImages[row]["image_url"] as! String
                
                let imageURL = NSURL(string: imageURLString)
                
                let imageData = NSData(contentsOfURL: imageURL!)
                
                let imageSelected = UIImage(data: imageData!)
                
                self.imageToGuessScreen = imageSelected!
                
                guessVC.imageToGuessScreen = imageToGuessScreen
                
                println("Next Screen")
                
            }
            
        }
        
    }
    
    
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
