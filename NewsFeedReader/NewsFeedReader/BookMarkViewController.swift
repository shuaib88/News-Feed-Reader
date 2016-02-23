//
//  BookMarkViewController.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/21/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class BookMarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    weak var delegate: DetailBookmarkDelegate?
    
    // the array that has stuff in it
    var favoritesArray: [[String:AnyObject]]?
    
    // defaults dictionary
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // set self as delegates
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // set favorites array from the defaults dictionary
        favoritesArray = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]?

    }
    
    // MARK: - TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MasterTableViewCell", forIndexPath: indexPath) as! MasterTableViewCell

        let savedBookmarkItem = favoritesArray![indexPath.row]
        
        // get title, content, and date
        let title = savedBookmarkItem["titleNoFormatting"]! as? String
        let content = savedBookmarkItem["content"]! as? String
        let date = savedBookmarkItem["publishedDate"]! as? String
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
    
    // allows delete or insert to happen
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            favoritesArray!.removeAtIndex(indexPath.row)
            deleteFavoriteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // not implementing insert
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedObject = favoritesArray![indexPath.row]
        delegate?.bookmarkPassedObject(selectedObject)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    // MARK: edit methods
    
    // stuck on how to make editing mode work
    @IBAction func enterEditingMode(sender: AnyObject) {
        editing = !editing
        tableView.setEditing(editing, animated: true)
    }
    
    // delete item from bookmarks array
    func deleteFavoriteItem(index: Int) -> Void {
        // if defaults has values, add item to bookmarks dictionary
        var array = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]?
            
        // append item to array
        array!.removeAtIndex(index)
        
        // re-add the array to nsuserdefaults
        defaults.setObject(array, forKey: "favoritesArray")
    }
    
}
