//
//  SimpleVideoCamController.swift
//  SimpleVideoCam
//
//  Created by Simon Ng on 17/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SimpleVideoCamController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    let captureSession = AVCaptureSession()
    
    var videoFileOutput: AVCaptureMovieFileOutput?
    
    var currentDevice: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var isRecording = false
    
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
        
        if !isRecording {
            isRecording = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                self.cameraButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
            
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecording(toOutputFileURL: outputFileURL, recordingDelegate: self)
        } else {
            isRecording = false
            
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                self.cameraButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            
            cameraButton.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
        }
        
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playVideo" {
            let videoPlayerViewController = segue.destination as! AVPlayerViewController
            let videoFileURL = sender as! URL
            videoPlayerViewController.player = AVPlayer(url: videoFileURL)
        }
    }

}

extension SimpleVideoCamController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ output: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        if error != nil {
            print(error)
        }
        
        performSegue(withIdentifier: "playVideo", sender: outputFileURL)
        
    }
}

