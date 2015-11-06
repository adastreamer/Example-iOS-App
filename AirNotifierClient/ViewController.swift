//
//  ViewController.swift
//  AirNotifierClient
//
//  Created by Dongsheng Cai on 6/11/2015.
//  Copyright © 2015 Dongsheng Cai. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    func JSONStringify(value: AnyObject, prettyPrinted:Bool = false) -> String{

        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)

        if NSJSONSerialization.isValidJSONObject(value) {
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }

    func HTTPsendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
                }
        })
        
        task.resume() //Tasks are called with .resume()
        
    }

    func HTTPGet(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        //To get the URL of the receiver , var URL: NSURL? is used
        HTTPsendRequest(request, callback: callback)
    }
    func HTTPGetJSON(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    let jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }
    func HTTPPostJSON(url: String,
        jsonObj: AnyObject,
        callback: (String, String?) -> Void) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json",
            forHTTPHeaderField: "Content-Type")
            let jsonString = JSONStringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            HTTPsendRequest(request,callback: callback)
    }
    func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        if let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding){
                
                do{
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                        data,
                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                            return jsonObj
                    }
                }catch{
                    print("Error")
                }
        }
        return [String: AnyObject]()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        let btn = UIButton(type: UIButtonType.System) as UIButton
        btn.setTitle("Get device token ", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.grayColor()
        btn.addTarget(self, action: "clickMe:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.titleLabel?.font =  UIFont(name: "Palatino", size: 32)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 300, screenSize.width, 100)
        self.view.addSubview(btn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func clickMe(sender:UIButton!)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("token")
        print("token : \(token)")
        
        
        let alert = UIAlertController(title: "Token", message: token, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
            switch action.style {
                case .Default:
            
                self.HTTPGetJSON("http://itunes.apple.com/us/rss/topsongs/genre=6/json") {
                    (data: Dictionary<String, AnyObject>, error: String?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        if let feed = data["feed"] as? NSDictionary ,let entries = feed["entry"] as? NSArray{
                            for elem: AnyObject in entries{
                                if let dict = elem as? NSDictionary ,let titleDict = dict["title"] as? NSDictionary , let songName = titleDict["label"] as? String{
                                    print(songName)
                                }
                            }
                        }
                    }
                }
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

