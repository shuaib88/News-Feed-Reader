//
//  DetailViewController.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/18/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import SafariServices

import UIKit

class DetailViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet var webView: UIWebView!
    
    // user defaults
    let defaults = NSUserDefaults.standardUserDefaults()

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
                
                detailItem = defaults.objectForKey("lastClickedArticle") as? [String:AnyObject]
//                let storedDetailItem = defaults.objectForKey("lastClickedArticle")
                
                // set url
                url = detailItem!["unescapedUrl"] as? String
//                url = storedDetailItem!["unescapedUrl"] as? String
                
                // open webView
                loadAddressUrl()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                self.configureView()
    }
    
    /// MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentAsPopover" {
            print("Present as popover segue triggered")
        }
    }
    @IBAction func addToBookmark(sender: UIBarButtonItem) {
        // if defaults has values, add item to bookmarks dictionary
        if var array = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]? {
            
            // append item to array
            array.append(detailItem!)
            
            // re-add the array to nsuserdefaults
            defaults.setObject(array, forKey: "favoritesArray")

        } else {
            // initializes defaults with an empty array of strings
            let defaultsArray: [[String:AnyObject]] = []
            defaults.setObject(defaultsArray, forKey: "favoritesArray")
        }
        
    }
    
    /// MARK: Sarari Controller Methods
    
    /// - Attributions: https://www.youtube.com/watch?v=Rva9ylPHi2w
    func loadAddressUrl() {

//        let requestURL = NSURL(string: url!)
//        let request = NSURLRequest(URL: requestURL!)
//        print(request.dynamicType)
        
        if let url = url {
            if let requestURL = NSURL(string: url) {
                let request = NSURLRequest(URL: requestURL)
                webView.loadRequest(request)
            }
        }
    }


}

