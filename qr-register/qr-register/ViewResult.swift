//
//  ViewResult.swift
//  qr-register
//
//  Created by saranpol on 3/22/2559 BE.
//  Copyright © 2559 hlpth. All rights reserved.
//

import UIKit

class ViewResult: UIViewController, UIAlertViewDelegate {
    
    var mUID: String = ""
    var mIsRegister = false
    @IBOutlet weak var mLabelRegisted: UILabel!
    @IBOutlet weak var mButtonHome: UIButton!
    @IBOutlet weak var mButtonRegister: UIButton!
    @IBOutlet weak var mLoading: UIActivityIndicatorView!
    
    var mJson: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mLabelRegisted.hidden = true
        mButtonHome.hidden = true
        mButtonRegister.hidden = true
        mLoading.hidden = false
        
        updateData()
    }

    func updateData() {
        //mUID = "10205999986226652"

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
//        let activate = "0"
        if(activate == "0"){
            mLabelRegisted.hidden = true
            mButtonHome.hidden = true
            mButtonRegister.hidden = false
        }else if(activate == "1"){
            mLabelRegisted.hidden = false
            mButtonHome.hidden = false
            mButtonRegister.hidden = true
        }else {
            
        }
    }
    
    
    func backStep() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickBack(_: AnyObject) {
        backStep()
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
            backHome()
        }else{
            backStep()
        }
    }
    
    @IBAction func clickRegister(_: AnyObject) {
        mLabelRegisted.hidden = true
        mButtonHome.hidden = true
        mButtonRegister.enabled = false
        mLoading.hidden = false
        mIsRegister = true
        
        API.a.api_activate(mUID) { (r) -> Void in
            self.mLoading.hidden = true
            self.mButtonRegister.enabled = true
            
//            self.errorActivate()
            
            if(r.result.error == nil){
                let activate = API.a.getActivate(r.result.value)
                if(activate == "ok"){
                    let v = UIAlertView(title: "ลงทะเบียน", message: "เสร็จสมบูรณ์", delegate: self, cancelButtonTitle: "ตกลง")
                    v.show()
                }else{
                    self.errorActivate()
                }
            }else{
                self.errorActivate()
            }
        }
    }
 
    
}
