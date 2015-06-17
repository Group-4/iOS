//
//  SubmitViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

protocol SubmitImageDelegate {
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage)
}

class SubmitViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var submitImageView: UIImageView!
    var cameraOriginal: UIImage?
    
    var imageDelegate: SubmitImageDelegate!
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if cameraOriginal != nil {
            
            submitImageView.image = cameraOriginal!
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage) {
        
        cameraOriginal = imageToSubmitViewController
      
        
    }

}
