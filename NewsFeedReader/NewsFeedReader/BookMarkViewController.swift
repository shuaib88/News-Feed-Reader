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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
