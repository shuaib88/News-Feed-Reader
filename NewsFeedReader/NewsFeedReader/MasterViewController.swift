//
//  MasterViewController.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/18/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    
    /// - Attributions: http://shrikar.com/swift-ios-tutorial-uisearchbar-and-uisearchbardelegate/ SearchBar

    @IBOutlet weak var searchBar: UISearchBar!
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    // This will hold my data from the API call
    var searchResponse = [[String:AnyObject]]()
    
    // the url of the query
    var searchQuery: String?
    let searchBase = "https://ajax.googleapis.com/ajax/services/search/news?v=1.1&rsz=large&q="
  
    // defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getting detail controller to prepare for segue - DONT'T TOUCH 
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // assign Search Bar delegate
        searchBar.delegate = self
        
        if searchQuery == nil {
            searchQuery = searchBase + "apple"
        }
        
        // initialize a search
        if let _ = defaults.objectForKey("lastSearchTerm") {
            let savedSearchTerm = defaults.objectForKey("lastSearchTerm") as! String
            searchQuery = searchBase + savedSearchTerm
            print("Saved search term: \(savedSearchTerm) ✌️")
        } else {
            searchQuery = searchBase + "apple"
            print("Never Searched:🖕")
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        // search request
        searchRequest()
        
        // adding target (self) and action to refreshControl object of tableViewController
        self.refreshControl?.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResponse.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MasterTableViewCell", forIndexPath: indexPath) as! MasterTableViewCell

        let searchResult = searchResponse[indexPath.row]
        
        // get title, content, and date
        let title = searchResult["titleNoFormatting"]! as? String
        let content = searchResult["content"]! as? String
        let date = searchResult["publishedDate"]! as? String
        let formattedDate = Helper.dateFormatter(date!)
        
        // set cell title, content, date
        cell.dateLabel!.attributedText = formattedDate.html2attributedString()
        cell.titleLabel!.attributedText = title?.html2attributedString()
        cell.contentLabel!.attributedText = content?.html2attributedString()

        // stylize the font
        cell.dateLabel.font = UIFont (name: "HelveticaNeue", size: 15)
        cell.titleLabel.font = UIFont (name: "Helvetica-Bold", size: 20)
        cell.contentLabel.font = UIFont (name: "HelveticaNeue", size: 17)
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // responds to pull to refresh
    func refreshTable(refreshControl: UIRefreshControl) {
        searchRequest()
        refreshControl.endRefreshing()
    }    
    
    // MARK: Search Function
    
    // search request
    func searchRequest() -> Void {
        
        GoogleNetworkingManager.sharedInstance.searchRequest(self.searchQuery!) { (response) -> Void in
            
            // Test that response is not nil and unwrap
            // if nil then return so prevent reloading table unecesarily.
            guard let response = response else {
                self.makeAlertForNetworkError()
                return
            }
            
            // Set the response data to the view controller's 'searchResponse' property
            let apiCallResponse = response
            self.searchResponse = apiCallResponse["responseData"]!["results"]! as! [[String:AnyObject]]
            
            // force a reload data on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: SearchBarDelegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        let enteredText = searchBar.text!
        // build query
        searchQuery = searchBase + enteredText
        
        // save search term in nsuserdefaults
        defaults.setObject(enteredText, forKey: "lastSearchTerm")
        
        // make api call
        searchRequest()
        
        // exit search
        searchBar.resignFirstResponder()
        
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // get clicked object
                let searchResult = searchResponse[indexPath.row] as [String:AnyObject]
                
                // set controller to pass to
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                // set the controller's property
                controller.detailItem = searchResult
                
                // save the passed object in nsuserdefaults
                defaults.setObject(searchResult, forKey: "lastClickedArticle")
                
                // not sure what this is
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                print("splitViewController in Master \(self.splitViewController)")
            }
        }
    }
    
    /// Helper functions
    /// creates an alertview for network errors
    func makeAlertForNetworkError() -> Void {
        let alertController = UIAlertController(title: "Network Error", message: "Get some Internets, Fool 👻👻👻", preferredStyle: .ActionSheet)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            return
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            return
        }
    }
    
}

/// - Attributions: lecture slides 8 
// extends String to provide a method for handling html tags
extension String {
    func html2attributedString() -> NSAttributedString {
        let attrStr = try! NSAttributedString( data: self.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        return attrStr
    }
}
