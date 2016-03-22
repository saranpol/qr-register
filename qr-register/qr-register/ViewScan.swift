//
//  ViewScan.swift
//  qr-register
//
//  Created by saranpol on 3/22/2559 BE.
//  Copyright © 2559 hlpth. All rights reserved.
//

import UIKit
import AVFoundation

class ViewScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var mViewPreview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = mViewPreview.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        mViewPreview.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
        let ac = UIAlertView(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", delegate: nil, cancelButtonTitle: "OK")
        ac.show()
        
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)

        let v = API.a.getViewController("Main", id: "ViewResult") as! ViewResult
        v.mUID = code
        
        navigationController?.pushViewController(v, animated: true)
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
//    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .Portrait
//    }
    
    @IBAction func clickBack(_: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}