//
//  ViewController.swift
//  TweetGram
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import OAuthSwift

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var loginLogoutButton: NSButton!
    let oauthswift = OAuth1Swift(
        consumerKey:    "rJsqNi9Nx9dLfq9ujMiOmC0xb",
        consumerSecret: "FrzQfDD1aSiwRXKDu6Hwaw2R9UhMXzqipy8utJYeH3N2vMA4i7",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
    
    var imageURLs: [String] = []
    var tweetURLs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 300, height: 300)
        layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        checkLogin()
    }
    
    func checkLogin() {
        if let oauthToken = UserDefaults.standard.string(forKey: "oauthToken") {
            if let oauthTokenSecret = UserDefaults.standard.string(forKey: "oauthTokenSecret") {
                oauthswift.client.credential.oauthToken = oauthToken
                oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
                getTweets()
                loginLogoutButton.title = "Logout"
            }
        }
        
    }
    
    func login() {
        // create an instance and retain it
        // authorize
        _ = oauthswift.authorize(
            withCallbackURL: URL(string: "TweetGram://oauth-callback/twitter")!,
            success: { credential, response, parameters in
            UserDefaults.standard.set(credential.oauthToken, forKey: "oauthToken")
                UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "oauthTokenSecret")
                UserDefaults.standard.synchronize()
                self.loginLogoutButton.title = "Logout"
                // print(credential.oauthToken)
                // print(credential.oauthTokenSecret)
                // print(parameters["user_id"])
                self.getTweets()
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
    }
    
    func logout() {
        loginLogoutButton.title = "Login"
        UserDefaults.standard.removeObject(forKey: "oauthToken")
        UserDefaults.standard.removeObject(forKey: "oauthTokenSecret")
        UserDefaults.standard.synchronize()
        imageURLs = []
        tweetURLs = []
        collectionView.reloadData()
    }
    
    func getTweets() {
        let _ = oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["tweet_mode":"extended", "count": 200],
                                      success: { response in
                                         if let dataString = response.string {
                                         print(dataString)
                                         }
                                        
                                        do {
                                            let json = try JSON(data: response.data)
                                            for (_, tweetJson):(String, JSON) in json {
                                                
                                                var retweeted = false
                                                
                                                for (_, mediaJson):(String, JSON) in tweetJson["retweeted_status"]["extended_entities"]["media"] {
                                                    retweeted = true
                                                    print(mediaJson["media_url_https"])
                                                    self.imageURLs.append(mediaJson["media_url_https"].stringValue)
                                                    self.tweetURLs.append(mediaJson["expanded_url"].stringValue)
                                                }
                                                
                                                if (retweeted == false) {
                                                    // print(tweetJson["entities"]["media"])
                                                    for (_, mediaJson):(String, JSON) in tweetJson["extended_entities"]["media"] {
                                                        print(mediaJson["media_url_https"])
                                                        self.imageURLs.append(mediaJson["media_url_https"].stringValue)
                                                        self.tweetURLs.append(mediaJson["expanded_url"].stringValue)
                                                    }
                                                }
                                                
                                            }
                                            print(self.imageURLs)
                                            self.collectionView.reloadData()
                                        } catch {print("Parsing JSON failed")}
        },
                                      failure: { error in
                                        print(error)
        }
        )
    }
    
    @IBAction func loginLogoutClicked(_ sender: NSButton) {
        if loginLogoutButton.title == "Login" {
            login()
        } else {
            logout()
        }
    }
    
    // MARK: -
    // MARK: Collection View Delegate
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "TweetGramItem", for: indexPath)
        let url = URL(string: imageURLs[indexPath.item])
        item.imageView?.kf.setImage(with: url)
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.deselectAll(nil)
        print("clicked \(indexPaths)")
        if let indexPath = indexPaths.first {
            if let url = URL(string: tweetURLs[indexPath.item]) {
                NSWorkspace.shared().open(url)
            }
        }
    }
}

