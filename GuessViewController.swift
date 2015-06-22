//
//  GuessViewController.swift
//  PictureQ
//
//  Created by jpk on 6/19/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class GuessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageToGuessScreen: UIImage?
    var nameToGuessScreen: String?
    var solvedToGuessScreen: String?
    var solvedToGuessID: Int?
    var dataFromRails: [AnyObject] = []
    var guessedArray: [String] = []
    
    @IBOutlet weak var imageGuessView: UIImageView!
    @IBOutlet weak var userNameGuessLabel: UILabel!
    @IBOutlet weak var solvedGuessLabel: UILabel!

    @IBOutlet weak var guessTextField: WelcomeTextField!
    
    @IBOutlet weak var guessedTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = THEME_BLUE
        navigationController?.navigationBar.tintColor = RICE_FLOWER
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageGuessView.layer.cornerRadius = CGFloat(10)
        imageGuessView.clipsToBounds = true
        imageGuessView.image = imageToGuessScreen!
        
        userNameGuessLabel.text = nameToGuessScreen
        solvedGuessLabel.text = solvedToGuessScreen
        
        guessedTableView.dataSource = self
        guessedTableView.delegate = self
        
        println(solvedToGuessID)
        
        HTTPRequest.session().getImages { () -> Void in
            
            self.dataFromRails = HTTPRequest.session().getDataFromRailsArray
            
        }
        
        let tapper = UITapGestureRecognizer(target: self.view, action:Selector("endEditing:"))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessButtonPressed(sender: AnyObject) {
        
        if self.guessTextField.isFirstResponder() {
            self.guessTextField.resignFirstResponder()
        }
        
        let guessToSend = guessTextField.text
        guessedArray.insert("\(guessToSend)", atIndex: 0)
        
        
        HTTPRequest.session().postGuess(solvedToGuessID!, guessToSendToRails: guessToSend)
        
        guessTextField.text = ""
        
        self.guessedTableView.reloadData()
        
        println("This sent, supposedly")
        
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("guess array " + "\(guessedArray.count)")

        return guessedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("guessCell", forIndexPath: indexPath) as! GuessTableViewCell
        
        println("This is cell " + "\(cell)")
        
        cell.guessCellLabel.text = String(guessedArray[indexPath.row])
        
        return cell
    }
 
    

}
