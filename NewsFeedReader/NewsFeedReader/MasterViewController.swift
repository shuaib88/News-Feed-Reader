//
//  MasterViewController.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/18/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    // This will hold my data from the API call
    var searchResponse = [[String:AnyObject]]()
    
    // the url of the query
    var searchQuery: String = "https://ajax.googleapis.com/ajax/services/search/news?v=1.1&rsz=large&q=apple"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // added edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // add an "add button" with the prescribed action
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        // getting detail controller to prepare for segue - DONT'T TOUCH 
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        
        // search request
        GoogleNetworkingManager.sharedInstance.searchRequest(self.searchQuery) { (response) -> Void in
            
            // Test that response is not nil and unwrap
            // if nil then return so prevent reloading table unecesarily. 
            guard let response = response else {
                self.makeAlertForNetworkError()
                return
            }
            
            // Set the response data to the view controller's 'searchResponse' property
            let apiCallResponse = response
            self.searchResponse = apiCallResponse["responseData"]!["results"]! as! [[String:AnyObject]]
            
            print(self.searchResponse[1]["titleNoFormatting"])
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    // inserting objects
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(searchResponse.count)
        
        return searchResponse.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

//        let object = objects[indexPath.row] as! NSDate
        let searchResult = searchResponse[indexPath.row]
        
        // set textLabel
        cell.textLabel!.text = searchResult["titleNoFormatting"]!.description
        
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

