//
//  ViewController.swift
//  qr-register
//
//  Created by saranpol on 3/22/2559 BE.
//  Copyright © 2559 hlpth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mH_Logo: NSLayoutConstraint!
    @IBOutlet weak var mW_Logo: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.a.mVC = self
        
        // Enable swipe back when no navigation bar
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        
        if(UIScreen.mainScreen().bounds.width >= 768){
            mW_Logo.constant = 157*1.5;
            mH_Logo.constant = 143*1.5;
        }
        
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    @IBAction func clickBackEnd(_: AnyObject) {
        let url = NSURL(string: "http://www.singhayaijadhai.com/backend")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

