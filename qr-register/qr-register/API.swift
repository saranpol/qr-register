//
//  API.swift
//  horo-for-touch-id
//
//  Created by saranpol on 10/16/2557 BE.
//  Copyright (c) 2557 hlpth. All rights reserved.
//

import UIKit

let API_HOST = "www.singhayaijadhai.com/api"

private let _singletonInstance = API()


class API {
    
    var mVC: ViewController?
    
    class var a: API {
        return _singletonInstance
    }
    
    init(){

    }
    
    func getViewController(sid:String, id:String) -> UIViewController {
        let storyboard = UIStoryboard(name: sid, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(id)
    }
    
    func getAPIUrl(name:String, isHttps:Bool) -> String {
        var http = "http://"
        if(isHttps){
            http = "https://"
        }
        return http + API_HOST + "/" + name
    }
    
    typealias Res = Response<AnyObject, NSError> -> Void
    
    // #########
    //    API
    // #########
    

    func api_member(uid: String, res: Res) {
        let url = getAPIUrl("member/" + uid, isHttps: false)
        //        var p = [String:String]()
        //        p["time"] = String(NSDate().timeIntervalSince1970)
        request(.GET, url, parameters: nil).responseJSON(completionHandler: res)
    }
    

    func api_activate(uid: String, res: Res) {
        let url = getAPIUrl("activate/" + uid, isHttps: false)
        //        var p = [String:String]()
        //        p["time"] = String(NSDate().timeIntervalSince1970)
        request(.GET, url, parameters: nil).responseJSON(completionHandler: res)
    }
    
    func getActivate(d: AnyObject?) -> String {
        return d?.objectForKey("activate") as? String ?? ""
    }
    
    func getFirstName(d: AnyObject?) -> String {
        return d?.objectForKey("first_name") as? String ?? ""
    }
    
    func getLastName(d: AnyObject?) -> String {
        return d?.objectForKey("last_name") as? String ?? ""
    }
    
    
    // Data Store
    
    func deleteData(key: String) {
        let u = NSUserDefaults.standardUserDefaults()
        u.removeObjectForKey(key)
        u.synchronize()
    }
    
    func saveData(data: AnyObject?, key: String) {
        if(data != nil){
            let u = NSUserDefaults.standardUserDefaults()
            u.setValue(NSKeyedArchiver.archivedDataWithRootObject(data!), forKey: key)
            u.synchronize()
        }
    }
    
    func loadData(key: String) -> AnyObject? {
        let u = NSUserDefaults.standardUserDefaults()
        let data: AnyObject! = u.valueForKey(key)
        if data != nil {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData)
        }
        return nil
    }
    
    
 
}



extension NSNull {
    func length() -> Int { return 0 }
    func integerValue() -> Int { return 0 }
    func floatValue() -> CGFloat { return 0 }
    func objectForKey(key:NSObject) -> AnyObject? { return nil }
    func objectAtIndex(i:Int) -> AnyObject? { return nil }
    func boolValue() -> Bool { return false }
}

