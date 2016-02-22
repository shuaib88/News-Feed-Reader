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
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet var webView: UIWebView!

    // when passed froms segue detail item is a specific response object [[String:AnyObject]]
    var detailItem: [String:AnyObject]?
    
    // url to be populated by passed object
    var url: String?
    
    // test url
    var urlPATH = "http://www.google.com"
    
    // configures the elements of the view when called
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            if let _ = webView {
                // set url
                url = detail["unescapedUrl"] as? String
                
                // open webView
                loadAddressUrl()
            }
            

            
            // if let label = self.detailDescriptionLabel {
                
                // test that url is correctly loading -- delete later
                // label.text = "http://www.google.com"
                
                // set url
                url = detail["unescapedUrl"] as? String
                
                // open webView
                loadAddressUrl()
                
                
            // }
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

