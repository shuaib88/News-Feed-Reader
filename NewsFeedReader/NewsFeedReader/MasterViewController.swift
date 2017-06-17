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
    let defaults = UserDefaults.standard
    
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
        if let _ = defaults.object(forKey: "lastSearchTerm") {
            let savedSearchTerm = defaults.object(forKey: "lastSearchTerm") as! String
            searchQuery = searchBase + savedSearchTerm
            print("Saved search term: \(savedSearchTerm) ✌️")
        } else {
            searchQuery = searchBase + "apple"
            print("Never Searched:🖕")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // search request
        searchRequest()
        
        // adding target (self) and action to refreshControl object of tableViewController
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.refreshTable(_:)), for: UIControlEvents.valueChanged)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResponse.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterTableViewCell", for: indexPath) as! MasterTableViewCell

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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // responds to pull to refresh
    func refreshTable(_ refreshControl: UIRefreshControl) {
        searchRequest()
        refreshControl.endRefreshing()
    }    
    
    // MARK: Search Function
    
    // search request
    func searchRequest() -> Void {
        
        /// - Attributions: http://stackoverflow.com/questions/24879659/how-to-encode-a-url-in-swift
        let url = self.searchQuery!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print (url)
        
        GoogleNetworkingManager.sharedInstance.searchRequest(url!) { (response) -> Void in
            
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: SearchBarDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let enteredText = searchBar.text!
        // build query
        searchQuery = searchBase + enteredText
        
        // save search term in nsuserdefaults
        defaults.set(enteredText, forKey: "lastSearchTerm")
        
        // make api call
        searchRequest()
        
        // exit search
        searchBar.resignFirstResponder()
        
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // get clicked object
                let searchResult = searchResponse[indexPath.row] as [String:AnyObject]
                
                // set controller to pass to
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                // set the controller's property
                controller.detailItem = searchResult
                
                // save the passed object in nsuserdefaults
                defaults.set(searchResult, forKey: "lastClickedArticle")
                
                // not sure what this is
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    /// Helper functions
    /// creates an alertview for network errors
    func makeAlertForNetworkError() -> Void {
        let alertController = UIAlertController(title: "Network Error", message: "Get some Internets, Fool 👻👻👻", preferredStyle: .actionSheet)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            return
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            return
        }
    }
    
}

/// - Attributions: lecture slides 8 
// extends String to provide a method for handling html tags
extension String {
    func html2attributedString() -> NSAttributedString {
        let attrStr = try! NSAttributedString( data: self.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        return attrStr
    }
}
