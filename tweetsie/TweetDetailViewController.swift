//
//  TweetDetailViewController.swift
//  tweetsie
//
//  Created by Deepak Agarwal on 9/29/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate {
    func tweetFavorated (tweetIndes:Int)
}
class TweetDetailViewController: UIViewController {
    
    var tweetIndex:Int!
    var tweetsCopy: [Tweet]?
    var didCallFavorate:Bool = false
    var delegate: TweetDetailViewControllerDelegate!
    
    
    @IBOutlet weak var retweetStaticButton: UIButton!
    @IBOutlet weak var topRetweetUserLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userTweetLabel: UILabel!
    
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    @IBOutlet weak var retweetTimesLabel: UILabel!
    
    @IBOutlet weak var tweetFavLabel: UILabel!
    
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var favorateButton: UIButton!
    
    @IBOutlet weak var userTweetReply: UITextView!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retweetStaticButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
         navigationController?.navigationBar.barTintColor =  UIColor(red: 0.24, green:0.47, blue:0.85 , alpha:1.0)
        self.populateTweet()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomePressed(sender: AnyObject) {
        println("onTapBack received")
        goBackToHome()
    }
    
    func goBackToHome()
    {
        delegate.tweetFavorated(tweetIndex)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func populateTweet() {
        if(tweetsCopy != nil)
        {
            var tweetItem = tweetsCopy?[tweetIndex]
            
            var retLabel = "\((tweetItem?.user?.name)!) retweeted"
            
            /*   if(retLabel != nil)
            {
            self.topRetweetUserLabel.text = "\(retLabel!) retweeted"
            } */
            
            var tweetUrl = tweetItem?.user?.profileImageUrl
            if(tweetUrl != nil)
            {
                println("  profileImageUrl = \(tweetUrl!)")
                userImage.setImageWithURL(NSURL(string: tweetUrl!))
            }
            
            userNameLabel.text = tweetItem?.user?.name
            
            var sn = tweetItem?.user?.screenname
            userScreenName.text = "@" + sn!
            userTweetLabel.text = tweetItem?.text
            tweetTimeLabel.text = tweetItem?.createdAtString
            retweetTimesLabel.text = "\((tweetItem?.retweetCount)!) RETWEETS"
            tweetFavLabel.text = "\((tweetItem?.favoriteCount)!) FAVORITES"
            
            if(tweetItem?.favorited == true)
            {
                favorateButton.setImage(UIImage(named: "favorite_on.png"),forState: .Normal)
                favorateButton.tintColor = UIColor.orangeColor()
            }
            else
            {
                favorateButton.setImage(UIImage(named: "favorite.png"),forState: .Normal)
                favorateButton.setImage(UIImage(named: "favorite_hover.png"),forState: .Highlighted)
            }
            replyButton.setImage(UIImage(named: "reply.png"), forState: .Normal)
            
            if(tweetItem?.retweeted == true)
            {
                retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
                retweetButton.tintColor = UIColor.orangeColor()
            }
            else
            {
                retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
                retweetButton.setImage(UIImage(named: "retweet_hover.png"), forState: .Highlighted)
            }
            
            
        }
        
        
    }
    
    @IBAction func onReplyPressed(sender: AnyObject) {
        println("onReplyPressed")
        var myTweet = userTweetReply.text
        if(myTweet != nil || myTweet != "")
        {
            let reply = myTweet!
            var tweetItem = tweetsCopy?[tweetIndex]
            var author = (tweetsCopy?[tweetIndex].user?.screenname)!
            var response = "@\(author) \(reply)"
            println(" reply = \(reply) response = \(response)")
            let par:Int = tweetItem!.id_int!
            println(" in_reply_to_status_id = \(par)")
            var parameterInt:NSDictionary = ["in_reply_to_status_id":par, "status":response]
            
            var url_post = "1.1/statuses/update.json" as String
            TweetsieClient.sharedInstance.tweetSelf(url_post, index: tweetIndex, params: parameterInt,    tweetCompletionError: { (url_post, index, error) -> () in
                println("error replying to the post")
            })
        }
        goBackToHome()
    }
    
    @IBAction func onRetweetPressed(sender: AnyObject) {
        println("onRetweetPressed")
        var tweetItem = tweetsCopy?[tweetIndex]
        var previousState = tweetItem?.retweeted
        tweetItem?.retweeted = true
        let par:Int = tweetItem!.id_int!
        var parameterInt:NSDictionary = ["id":par]
        
        var id_str = tweetItem?.id_str
        
        var url_post = "1.1/statuses/retweet/\(par).json" as String
        
        TweetsieClient.sharedInstance.retweet(url_post, index: tweetIndex, params: nil, retweetCompletionError: { (url_post, index, error) -> () in
            var tweet = self.tweetsCopy?[index!]
            tweet?.retweeted = previousState
            self.populateTweet()
        })
        
        populateTweet()
    }
    
    @IBAction func onFavPressed(sender: AnyObject) {
        println("onFavPressed")
        
        var tweetItem = tweetsCopy?[tweetIndex]
        var previousState = tweetItem?.favorited
        tweetItem?.favorited = true
        
        
        let par:Int = tweetItem!.id_int!
        println("onFavPressed id  = \(par) ")
        var parameterInt:NSDictionary = ["id":par]
        
        
        var url_post = "1.1/favorites/create.json" as String
        TweetsieClient.sharedInstance.tweetSelf(url_post, index: tweetIndex, params: parameterInt,    tweetCompletionError: { (url_post, index, error) -> () in
            println("error replying to the post error = \(error)")
            var tweet = self.tweetsCopy?[index!]
            tweet?.favorited = previousState
            self.populateTweet()
        })
        
        populateTweet()
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
