//
//  CameraViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/11/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController : UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    
    // start with a session
    
    private let captureSession = AVCaptureSession()
    
    // find the camera
    
    private var captureDevice : AVCaptureDevice?
    
    // view did  Load
    
    private var cameraPosition = AVCaptureDevicePosition.Back
    
    private var stillImageOutput : AVCaptureStillImageOutput?
    
    private var previewLayer : AVCaptureVideoPreviewLayer?
    
    
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
    
    
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            if findCamera(cameraPosition) {
                beginSession()
        //Start the session
            } else {
        //show sad error message
}
    }
    
    
    // fincd camera function

    // Start the Capture Session
    func beginSession() {
        var err: NSError? = nil
        
        let videoCapture = AVCaptureDeviceInput(device: captureDevice, error: &err)
        
        if err != nil {
            println("Couldn't start session: \(err?.description)")
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




}
