//
//  ViewController.swift
//  qr-register
//
//  Created by saranpol on 3/22/2559 BE.
//  Copyright © 2559 hlpth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.a.mVC = self
        
        // Enable swipe back when no navigation bar
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
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
}

