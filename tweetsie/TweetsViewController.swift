//
//  TweetsViewController.swift
//  tweetsie
//
//  Created by Deepak Agarwal on 9/28/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

let tweetsDownloaded = "tweetsDownloaded"
class TweetsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, TweetDetailViewControllerDelegate {

       
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tintColor = UIColor.lightGrayColor()
        tableView.separatorColor = UIColor.darkGrayColor()

         NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: tweetsDownloaded, object: nil)
        
        TweetsieClient.sharedInstance.homeTimeWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
        // Do any additional setup after loading the view.
         self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTable() {
        println("updateTable called")
        self.tableView.reloadData()
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if (tweets?.count == nil)
        {
            return 0;
        }
        else
        {
            return tweets!.count
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var cellTweet = tweets?[indexPath.row]
        
        
        var retLabel = "\((cellTweet?.user?.name)!) retweeted"
        
        /*   if(retLabel != nil)
        {
            cell.topRetweetUser.text = "\(retLabel!) retweeted"
        } */
        

        
        var tweetUrl = cellTweet?.user?.profileImageUrl
        if(tweetUrl != nil)
        {
            println("  profileImageUrl = \(tweetUrl!)")
           cell.tweetUserImage.setImageWithURL(NSURL(string: tweetUrl!))
        }

        cell.tweetUser.text = cellTweet?.user?.name
        
        cell.tweetUserSN.text = cellTweet?.user?.screenname
        cell.tweetCreatedTime.text = cellTweet?.createdAtString
        cell.tweetText.text = cellTweet?.text
        
        
        if(cellTweet?.favorited == true)
        {
            cell.favButton.setImage(UIImage(named: "favorite_on.png"),forState: .Normal)
        }
        else
        {
            cell.favButton.setImage(UIImage(named: "favorite.png"),forState: .Normal)
            cell.favButton.setImage(UIImage(named: "favorite_hover.png"),forState: .Highlighted)
        }
        cell.replyButton.setImage(UIImage(named: "reply.png"), forState: .Normal)
        
        if(cellTweet?.retweeted == true)
        {
            cell.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
        }
        else
        {
            cell.retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
            cell.retweetButton.setImage(UIImage(named: "retweet_hover.png"), forState: .Highlighted)
        }
        

        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var tweetDetinationNavigationController = segue.destinationViewController as UINavigationController
        if(segue.identifier == "tweetDetailSegue")
        {
            var tweetDetailsViewController = tweetDetinationNavigationController.viewControllers[0] as TweetDetailViewController
            var index = tableView.indexPathForSelectedRow()?.row
            println(" tweet index = \(index!)")
            tweetDetailsViewController.tweetIndex = index!
            tweetDetailsViewController.tweetsCopy = tweets
            tweetDetailsViewController.delegate = self
        }
        else
        {
            var composeViewController = tweetDetinationNavigationController.viewControllers[0] as ComposeViewController
            
        }
    }

    func tweetFavorated(tweetIndex: Int)
    {
        updateTable()
    }
}
