//
//  SimpleVideoCamController.swift
//  SimpleVideoCam
//
//  Created by Simon Ng on 17/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleVideoCamController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    let captureSession = AVCaptureSession()
    
    var videoFileOutput: AVCaptureMovieFileOutput?
    
    var currentDevice: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSessionPresetHigh

        //Get the default camera
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        currentDevice = device
        
        //Get the input data source
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        videoFileOutput = AVCaptureMovieFileOutput()
        
        //Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(videoFileOutput)
        
        //Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        //Bring the camera button to front
        view.bringSubview(toFront: cameraButton)
        captureSession.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func capture(sender: AnyObject) {
    }


}
