//
//  TweetsieClient.swift
//  tweetsie
//
//  Created by Deepak Agarwal on 9/28/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

let tweetsieConsumerKey = "4trKCuNq0wsTTU4Ck80ic2Bnl"
let tweetsieConsumerSecret = "xUzb6VZa2s2w1jIViZMAjE9f5tASlaAPi9kVnikr66M4OaYgGs"
let tweetsieBaseURL: NSURL =  NSURL(string: "https://api.twitter.com/")



class TweetsieClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TweetsieClient {
    struct Static {
        static let instance = TweetsieClient(baseURL: tweetsieBaseURL, consumerKey: tweetsieConsumerKey, consumerSecret: tweetsieConsumerSecret)
        }
        return Static.instance
    }
    func homeTimeWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        println("homeTimeWithParams called on Twitterclient")
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            // println("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(tweetsDownloaded, object: nil)
            
            
            }, failure: { (operaton:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting current user \(error)")
                completion(tweets: nil, error: error)
                self.loginCompletion?(user: nil, error: error)
        })
        
        
    }
    
    func retweet(url_post: String?, index: Int?, params: NSDictionary?, retweetCompletionError: (url_post: String?, index: Int?, error: NSError?) -> ()) {
        //var url_post = "1.1/statuses/retweet/\(id_str!).json" as String
        println("url = \(url_post!)")
        
        POST(url_post!,  parameters: params, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("home retweet response: \(response)")
            // var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            }, failure: { (operaton:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error retweeting tweet_id=\(url_post!) index =\(index!)")
                println("error retweeting error=\(error)")
                retweetCompletionError(url_post: url_post, index: index, error: error)
        })
        
        
    }
    
    /*    func tweetSelf (url_post: String?, params: NSDictionary?, tweetCompletionError: (url_post: String?, error: NSError?) -> ()) {
    println("url = \(url_post!)")
    
    POST(url_post!,  parameters: params, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
    println("tweet response: \(response)")
    
    }, failure: { (operaton:AFHTTPRequestOperation!, error: NSError!) -> Void in
    println("error tweeting tweet_id=\(url_post!) ")
    tweetCompletionError(url_post: url_post, error: error)
    })
    
    
    } */
    func tweetSelf (url_post: String?, index: Int?, params: NSDictionary?, tweetCompletionError: (url_post: String?, index: Int?, error: NSError?) -> ()) {
        println("url = \(url_post!)")
        
        POST(url_post!,  parameters: params, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("tweet response: \(response)")
            
            }, failure: { (operaton:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error tweeting tweet_id=\(url_post!) ")
                tweetCompletionError(url_post: url_post, index: index, error: error)
        })
        
        
    }
    
    
    func loginWithCompletion (completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redirect to authorization page
        
        TweetsieClient.sharedInstance.requestSerializer.removeAccessToken()
        TweetsieClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"labs108tweetsie://oauth"), scope: nil, success: {(requestToken:BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func openURL( url: NSURL)
    {
        TweetsieClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken:BDBOAuthToken!) -> Void in
            println("Got the access token!")
            TweetsieClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TweetsieClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) ->Void in
                //println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user = \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: {(operaton: AFHTTPRequestOperation!, error:NSError!) ->Void in
                    
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error:NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
}
