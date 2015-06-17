//
//  CameraViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit



class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SubmitImageDelegate {

    var cameraImagePicker = UIImagePickerController()
    var cameraOriginal: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraImagePicker.delegate = self
        cameraImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        cameraImagePicker.showsCameraControls = true
        cameraImagePicker.allowsEditing = false
        self.view.addSubview(cameraImagePicker.view)
        
        navigationController?.navigationBar.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage) {
        
        cameraOriginal = imageToSubmitViewController
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if let original = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.cameraOriginal = original
            println(cameraOriginal)
            
        }

        performSegueWithIdentifier("submitSegue", sender: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "submitSegue" {
            
            if let submitVC: SubmitViewController = segue.destinationViewController as? SubmitViewController {
                
                submitVC.imageDelegate = self
                
                println(submitVC.imageDelegate)
                
                submitVC.cameraOriginal = cameraOriginal

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

}
