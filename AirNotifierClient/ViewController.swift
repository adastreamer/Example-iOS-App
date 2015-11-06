//
//  ViewController.swift
//  AirNotifierClient
//
//  Created by Dongsheng Cai on 6/11/2015.
//  Copyright © 2015 Dongsheng Cai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

