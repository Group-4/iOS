//
//  GuessViewController.swift
//  PictureQ
//
//  Created by jpk on 6/19/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class GuessViewController: UIViewController {
    
    var imageToGuessScreen: UIImage?
    
    @IBOutlet weak var imageGuessView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageGuessView.image = imageToGuessScreen!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
