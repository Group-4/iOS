//
//  SubmitViewController.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit
import AFNetworking
import AFAmazonS3Manager

protocol SubmitImageDelegate {
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage)
}

class SubmitViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var answerToSubmitTextField: UITextView!
    @IBOutlet weak var submitImageView: UIImageView!
    var cameraOriginal: UIImage?
    var resizedImageToSubmit: UIImage?
    var imageURL: String?
    var imageDelegate: SubmitImageDelegate!
    var info: AnyObject?
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if cameraOriginal != nil {
            
            submitImageView.image = cameraOriginal!
            
        }
        
        submitImageView.layer.cornerRadius = CGFloat(10)
        submitImageView.clipsToBounds = true
        
        var newSize = CGSize(width: 640,height: 480)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        // image is a variable of type UIImage
        cameraOriginal?.drawInRect(rect)
        
        self.resizedImageToSubmit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Looks for single or multiple taps.
        let tapper = UITapGestureRecognizer(target: self.view, action:Selector("endEditing:"))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
        
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitImageToS3(sender: AnyObject) {
        
        saveImageToS3(resizedImageToSubmit!)
        println(resizedImageToSubmit)

        
    }
    
    @IBAction func submitImageAndAnswer(sender: AnyObject) {
        
        var postEndpoint: String = "http://tiyqpic.herokuapp.com/posts"
        let request = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
        
        request.HTTPMethod = "POST"
        let answerToSubmit = answerToSubmitTextField.text
        let urlToSubmit = imageURL
        let submitAnswerString = NSString(format: "image_url=%@&answer=%@", urlToSubmit!, answerToSubmit)
        request.HTTPBody = submitAnswerString.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue(HTTPRequest.session().token, forHTTPHeaderField: "Access-Token")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        
        task.resume()

        
    }
    
    func pushImageToSubmit(imageToSubmitViewController: UIImage) {
        
        cameraOriginal = imageToSubmitViewController
        
    }
    
    let s3Manager = AFAmazonS3Manager(accessKeyID: accessKey, secret: secret)
    
    func saveImageToS3(image: UIImage) {
        //make the image name dynamic
        let timestamp = Int(NSDate().timeIntervalSinceReferenceDate)
        //make it userName dynamic to replace myImage
        let imageName = "image_\(timestamp)"
        //
        let imageData = UIImagePNGRepresentation(image)
        s3Manager.requestSerializer.bucket = bucket
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion
        
        //save the file locally - need a file path - must be saved in documentdirectory
        //expand tilde to the back root path
        if let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as? String {
            
            let filePath = documentPath.stringByAppendingPathComponent(imageName + ".png")
            
            println(filePath)
            
            imageData.writeToFile(filePath, atomically: false)
            
            let fileURL = NSURL(fileURLWithPath: filePath)
            
            s3Manager.putObjectWithFile(filePath, destinationPath: imageName + ".png", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0
                
                println("Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let info = responseObject as! AFAmazonS3ResponseObject
                    
                    self.imageURL = info.URL.absoluteString
                    println(self.imageURL)
                    
                    println(responseObject)
                    
                }, failure: { (responseObject) -> Void in
                    
                    println(responseObject)
            })
            
        }
        
    }

}
