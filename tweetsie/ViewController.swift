//
//  ViewController.swift
//  tweetsie
//
//  Created by Deepak Agarwal on 9/27/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginPressed(sender: AnyObject) {
        TweetsieClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
                //perform segue
            } else {
                println("user is nil")
            }
        }
 
    }
}

