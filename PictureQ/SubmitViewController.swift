//
//  SubmitViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController, SubmitImageDelegate {
    
    @IBOutlet weak var submitImageView: UIImageView!
    var cameraOriginal: UIImage?
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage) {
        
        cameraOriginal = imageToSubmitViewController
        println(cameraOriginal)
        println("whats up")
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "submitSegue" {
        
//            let cameraVC = storyboard?.instantiateViewControllerWithIdentifier("cameraVC") as! CameraViewController
//            
//            cameraVC.imageDelegate = self
//            
//            self.navigationController?.pushViewController(cameraVC, animated: true)
            
            if let cameraVC: CameraViewController = segue.destinationViewController as? CameraViewController {
             
                cameraVC.imageDelegate = self
                
            }
            
        }
        
    }
  

}
