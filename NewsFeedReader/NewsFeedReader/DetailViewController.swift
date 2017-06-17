//
//  DetailViewController.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/18/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import SafariServices

import UIKit

import Social

class DetailViewController: UIViewController, DetailBookmarkDelegate, UIWebViewDelegate {

    
    /// MARK: Properties
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet weak var toolbar: UIToolbar!

    @IBOutlet weak var starImageView: UIImageView!
    // user defaults
    
    var _activityIndicator: ActivityIndicatorView?
    
    let defaults = UserDefaults.standard

    // when passed froms segue detail item is a specific response object [[String:AnyObject]]
    var detailItem: [String:AnyObject]?
    
    // url to be populated by passed object
    var url: String?
    
    // test url
    var urlPATH = "http://www.google.com"
    
    // configures the elements of the view when called
    func configureView() {
        // Update the user interface with either the detail item or stored item
        if let detail = self.detailItem {
            
            if let _ = webView {
                // set url
                url = detail["unescapedUrl"] as? String
                
                // open webView
                loadAddressUrl()
            } else {

            }
        } else {
            
            if let _ = webView {
                
                detailItem = defaults.object(forKey: "lastClickedArticle") as? [String:AnyObject]
//                let storedDetailItem = defaults.objectForKey("lastClickedArticle")
                
                // set url
                url = detailItem!["unescapedUrl"] as? String
//                url = storedDetailItem!["unescapedUrl"] as? String
                
                // open webView
                loadAddressUrl()
            }
        }
    }
    
    /// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.configureView()
        
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.configureView()
        
        checkIfCurrentArticleInFavorites()
        
//        let favoritesArray = defaults.valueForKey("favoritesArray") as! [[String:AnyObject]]
//        
//        for savedFavorite in favoritesArray {
//            
//            if savedFavorite["unescapedUrl"] as! String == detailItem!["unescapedUrl"] as! String {
//                view.bringSubviewToFront(starImageView)
//            } else {
//                view.sendSubviewToBack(starImageView)
//            }
//        }
    }
    
    /// MARK: Segues and actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentAsPopover" {
            
            // setting the DetailViewController to be delegate of Bookmark
            let destinationBookmarkController = segue.destination as! BookMarkViewController
            destinationBookmarkController.delegate = self
            
            destinationBookmarkController.detailController = self
            
            print("popover pressed")
        }
    }
    @IBAction func addToBookmark(_ sender: UIBarButtonItem) {
        // if defaults has values, add item to bookmarks dictionary
        if var array = defaults.object(forKey: "favoritesArray") as! [[String:AnyObject]]? {
            
            // append item to array
            array.append(detailItem!)
            
            // re-add the array to nsuserdefaults
            defaults.set(array, forKey: "favoritesArray")
            
            // updates star
            checkIfCurrentArticleInFavorites()

        } else {
            // initializes defaults with an empty array of strings
            let defaultsArray: [[String:AnyObject]] = []
            defaults.set(defaultsArray, forKey: "favoritesArray")
        }
        
    }
    
    func checkIfCurrentArticleInFavorites() -> Void {
        
        let favoritesArray = defaults.value(forKey: "favoritesArray") as! [[String:AnyObject]]
        
        for savedFavorite in favoritesArray {
            
            if savedFavorite["unescapedUrl"] as! String == detailItem!["unescapedUrl"] as! String {
                view.bringSubview(toFront: starImageView)
            } else {
                view.sendSubview(toBack: starImageView)
            }
        }
    }
    
    /// - Attributions: https://www.codementor.io/swift/tutorial/ios-development-facebook-twitter-sharing
    @IBAction func tweet(_ sender: UIBarButtonItem) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// MARK: Safari Controller Methods
    
    /// - Attributions: https://www.youtube.com/watch?v=Rva9ylPHi2w
    func loadAddressUrl() {
        if let url = url {
            if let requestURL = URL(string: url) {
                let request = URLRequest(url: requestURL)
                webView.loadRequest(request)
                
                // add an activity spinner
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        guard webView.isLoading == false else {
            return
        }
        self._activityIndicator!.removeFromSuperview()
    }
    
    // not sure how to use this
    func bookmarkPassedObject(_ clickedFavoriteObject: [String:AnyObject]) {
        // set detailItem to selected object
        detailItem = clickedFavoriteObject
        configureView()
    }
    
}

protocol DetailBookmarkDelegate: class {
    func bookmarkPassedObject(_ dictionary: [String:AnyObject]) -> Void
}

