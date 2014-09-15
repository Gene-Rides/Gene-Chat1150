//
//  CameraViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/11/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class CameraViewController : UIViewController, DBRestClientDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    // start with a session
    
    private let captureSession = AVCaptureSession()
    
    // find the camera
    
    private var captureDevice : AVCaptureDevice?
    
    // view did  Load
    
    private var cameraPosition = AVCaptureDevicePosition.Back
    
    private var stillImageOutput : AVCaptureStillImageOutput?
    
    private var previewLayer : AVCaptureVideoPreviewLayer?
    
    private var dbRestClient : DBRestClient?
    
    
    func findCamera(position: AVCaptureDevicePosition) -> Bool {
        let devices = AVCaptureDevice.devicesWithMediaType (AVMediaTypeVideo)
        
        
        //get device at the matching position
        
        for device in devices {
            if device.position == position {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        return captureDevice != nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !DBSession.sharedSession().isLinked() {
            
            DBSession.sharedSession().linkFromController(self)
        }
        
        if dbRestClient == nil {
            dbRestClient = DBRestClient(session: DBSession.sharedSession())
            dbRestClient!.delegate = self
        }
        
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if findCamera(cameraPosition) {
            beginSession()
            //Start the session
        } else {
            //show sad error message
        }
    }
    
    @IBAction func rewindFromSegue(segue:UIStoryboardSegue) {
        println("here is a return")
    }
    
    @IBAction func sendPhoto(segue:UIStoryboardSegue) {
        println("here is a return from photo")
        
    }
        @IBAction func sendPhotoWithFriends(segue:UIStoryboardSegue) {
            let (fileName, snapFileName) = getSnapFileName()
            let friendsViewController = segue.sourceViewController as FriendsViewController
            
            // Upload to parse
            var uploadFile = PFFile(name: fileName, contentsAtPath: snapFileName)
            uploadFile.saveInBackgroundWithBlock { (success:Bool, _) in
                if success {
                    println("Photo uploaded")
                    
                    
                    // Send to friends
                    let friends = friendsViewController.getTargetFriends()
                    println("About to send photo to \(countElements(friends)) friends")
                    
                    for friend in friends {
                        var msg = ChatPicture()
                        msg.fromUser = ChatUser.currentUser()
                        msg.toUser = friend
                        msg.image = uploadFile
                        msg.saveInBackground()
                    }
                }
            }
    }
    // fincd camera function
    
    // Start the Capture Session
    func beginSession() {
        var err: NSError? = nil
        
        let videoCapture = AVCaptureDeviceInput(device: captureDevice, error: &err)
        
        if err != nil {
            println("Couldn't start session: \(err?.description)")
            return
        }
        
        
        if captureSession.canAddInput(videoCapture) {
            captureSession.addInput(videoCapture)
        }
        
        if !captureSession.running {
            // setup JPEG output
            stillImageOutput = AVCaptureStillImageOutput()
            let outputSettings = [ AVVideoCodecKey : AVVideoCodecJPEG]
            stillImageOutput!.outputSettings = outputSettings
            
            // Add to output session
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
            //Display in UI
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraView.layer.addSublayer(previewLayer)
            previewLayer?.frame = cameraView.layer.frame
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            captureSession.startRunning()
            
            
        }
        
        
    }
    
    @IBAction func flipCamera(sender: UIButton) {
        // if a session is running, you must call this before caning
        captureSession.beginConfiguration()
        let currentInput = captureSession.inputs[0] as AVCaptureInput
        
        captureSession.removeInput(currentInput)
        
        cameraPosition = cameraPosition == .Back ? .Front : .Back
        
        
        if findCamera(cameraPosition) {
            beginSession()
        } else {
            
        }
        
        captureSession.commitConfiguration()
        
        
    }
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        //1: Grab the image output
        if let stillOutput = self.stillImageOutput {
            
            //we do this on another thread so we don't hang the UI
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                // Find the video connction
                var videoConnection : AVCaptureConnection?
                for connection in stillOutput.connections {
                    //find a matching input port
                    for port in connection.inputPorts!
                    {
                        // and matching tpe
                        if port.mediaType == AVMediaTypeVideo {
                            videoConnection = connection as? AVCaptureConnection
                            break //for port
                        }
                    }
                    if videoConnection != nil{
                        break //for connection
                    }
                }
                if videoConnection != nil {
                    // Found the video connection
                    stillOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                        (imageSampleBuffer:CMSampleBuffer!, _) in
                        
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                        
                        self.didTakePhoto(imageData)
                        
                    }
                }
            }
            
            
        }
    }
    
    class func getSnapFileName () -> (String, String) {
        let fileName = "lastSnap.jpg"
        let tmpDirectory = NSTemporaryDirectory()
        let snapFileName = tmpDirectory.stringByAppendingPathComponent(fileName)
        
        return (fileName, snapFileName)
        
    }
    
    func didTakePhoto(imageData: NSData){
        
        
        // if you want to show a thumbnail in the UI:
        let image = UIImage(data: imageData)
        
        
        let smallImage = compressImage(image)
        let (__, fullFileName) = CameraViewController.getSnapFileName()
        smallImage.writeToFile(fullFileName, atomically: true)
        
        
        var sendNav = self.storyboard?.instantiateViewControllerWithIdentifier("SendNav") as UIViewController!
        self.presentViewController(sendNav, animated: true, completion: nil)
        
        // IF YOU WANT TO SAVE THE IMAGE TO A FILE ..
        // var formatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        //let prefix: String = formatter.stringFromDate(NSDate())
        //let fileName = "\(prefix).jpg"
        
        //let tmpDirectory = NSTemporaryDirectory()
        //let snapFileName = tmpDirectory.stringByAppendingPathComponent(fileName)
        
        //smallImage.writeToFile(snapFileName, atomically: true)
        
        // Upload to DropBox
        // dbRestClient!.uploadFile(fileName, toPath: "/", withParentRev: nil, fromPath: snapFileName)
        

        
    }
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        println ("File uploaded successfully to path : \(metadata.path)")
        dbRestClient!.loadSharableLinkForFile(metadata.path, shortUrl: true)
    }
    
    func restClient(client: DBRestClient!, movePathFailedWithError error: NSError!) {
        println ("File upload failed with error: \(error)")
    }
    
    // Social Media Sharing segment - get a shaarable link from DropBox
    
    func restClient(restClient: DBRestClient!, loadedSharableLink link: String!, forFile path: String!) {
         println ("sharable link: \(link)")
        
        // Send it to Twitter if it is working
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText("GeneChat is awesome! \(link)")
            self.presentViewController(tweetSheet, animated: true, completion: nil)
        }
    }
    func restClient(restClient: DBRestClient!, loadSharableLinkFailedWithError error: NSError!) {
        println("Could not get shareable link")
    }
    
    func compressImage(image:UIImage) -> NSData {
        // Drops from 2MB -> 64 KB!!!
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = 1136.0
        var maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        var rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.drawInRect(rect)
        var img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData;
    }
}






