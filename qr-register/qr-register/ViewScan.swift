//
//  ViewScan.swift
//  qr-register
//
//  Created by saranpol on 3/22/2559 BE.
//  Copyright © 2559 hlpth. All rights reserved.
//

import UIKit
import AVFoundation

class ViewScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var mViewPreview: UIView!
    @IBOutlet weak var mH_ViewPreview: NSLayoutConstraint!
    @IBOutlet weak var mW_ViewPreview: NSLayoutConstraint!

    
    
    @IBOutlet weak var mH_Logo: NSLayoutConstraint!
    @IBOutlet weak var mW_Logo: NSLayoutConstraint!

    @IBOutlet weak var mB_panel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mImageRegisted.hidden = true
        mButtonHome.hidden = true
        mButtonBack.hidden = false
        mButtonRegister.hidden = true
        mImagePleaseRegister.hidden = true
        mLoading.hidden = true
        
        if(UIScreen.mainScreen().bounds.width >= 768){
            mW_Logo.constant = 157*1.5;
            mH_Logo.constant = 143*1.5;
            mB_panel.constant = 32;
        }
        
        
        let w = UIScreen.mainScreen().bounds.width * 0.7
        let h = UIScreen.mainScreen().bounds.width * 0.8
        mW_ViewPreview.constant = w
        mH_ViewPreview.constant = h
        
        
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRectMake(0, 0, w, h)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        mViewPreview.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
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
        mUID = code
        updateData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
//    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .Portrait
//    }
    
    @IBAction func clickBack(_: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    var mUID: String = ""
    var mIsRegister = false
    @IBOutlet weak var mImageRegisted: UIImageView!
    @IBOutlet weak var mImagePleaseRegister: UIImageView!
    @IBOutlet weak var mButtonHome: UIButton!
    @IBOutlet weak var mButtonRegister: UIButton!
    @IBOutlet weak var mButtonBack: UIButton!
    @IBOutlet weak var mLoading: UIActivityIndicatorView!
    
    var mJson: AnyObject?
 
    
    func updateData() {
        //mUID = "10205999986226652"
        mLoading.hidden = false
        mIsRegister = false
        API.a.api_member(mUID) { (r) -> Void in
            self.mLoading.hidden = true
            if(r.result.error == nil){
                self.mJson = r.result.value
                self.updateUI()
            }else{
                let v = UIAlertView(title: "รหัสผู้ใช้ไม่ถูกต้อง", message: "กรุณาลองใหม่อีกครั้ง", delegate: self, cancelButtonTitle: "ตกลง")
                v.show()
            }
        }
    }
    
    func updateUI() {
        let activate = API.a.getActivate(mJson)
//                let activate = "0"
        if(activate == "0"){
            mImageRegisted.hidden = true
            mButtonHome.hidden = true
            mButtonBack.hidden = false
            mButtonRegister.hidden = false
            mImagePleaseRegister.hidden = false
        }else if(activate == "1"){
            mImageRegisted.hidden = false
            mButtonHome.hidden = false
            mButtonBack.hidden = true
            mButtonRegister.hidden = true
            mImagePleaseRegister.hidden = true
        }else {
            
        }
    }
    
    
    func backStep() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func clickHome(_: AnyObject) {
        backHome()
    }
    
    func backHome() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func errorActivate() {
        let v = UIAlertView(title: "ลงทะเบียนไม่สำเร็จ", message: "กรุณาลองใหม่อีกครั้ง", delegate: nil, cancelButtonTitle: "ตกลง")
        v.show()
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if(mIsRegister){

        }else{
            if (captureSession?.running == false) {
                captureSession.startRunning();
            }
        }
    }
    
    @IBAction func clickRegister(_: AnyObject) {
        mImageRegisted.hidden = true
        mButtonHome.hidden = true
        mButtonBack.hidden = false
        mButtonRegister.enabled = false
        mLoading.hidden = false
        mIsRegister = true
        
        API.a.api_activate(mUID) { (r) -> Void in
            self.mLoading.hidden = true
            self.mButtonRegister.enabled = true
            
            
            if(r.result.error == nil){
                let activate = API.a.getActivate(r.result.value)
//                let activate = "ccc"
                if(activate == "ok"){
                    self.mImagePleaseRegister.hidden = true
                    self.mImageRegisted.hidden = false
                    self.mButtonHome.hidden = false
                    self.mButtonBack.hidden = true
                    self.mButtonRegister.hidden = true
                }else{
                    self.errorActivate()
                }
            }else{
                self.errorActivate()
            }
        }
    }
    
    
    
}
