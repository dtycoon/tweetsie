//
//  ComposeViewController.swift
//  tweetsie
//
//  Created by Deepak Agarwal on 9/29/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    var delegate: TweetDetailViewControllerDelegate!
    
    @IBOutlet weak var userInputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.barTintColor =  UIColor(red: 0.24, green:0.47, blue:0.85 , alpha:1.0)
        userName.text = User.currentUser?.name
        screenName.text = User.currentUser?.screenname
        var imageUrl = User.currentUser?.profileImageUrl
        if(imageUrl != nil)
        {
            println("  profileImageUrl = \(imageUrl!)")
            userImage.setImageWithURL(NSURL(string: imageUrl!))
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapCancel(sender: AnyObject) {
        println("onTapBack cancel")
        goHome()
    }
    
    func goHome()
    {
        delegate.tweetFavorated(0)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onTweetAction(sender: AnyObject) {
        var myTweet = userInputView.text
        if(myTweet != nil)
        {
            let address = myTweet!
            println(" tweet composition = \(address)")
            var parameter = ["status":address]
            var url_post = "1.1/statuses/update.json" as String
            
            TweetsieClient.sharedInstance.tweetSelf(url_post,index: 0, params: parameter, tweetCompletionError: { (url_post, index, error) -> () in
                println("error in tweetSelf = \(error)")
                return
            })
            goHome()
        }
        
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
