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
    
    // refrence to detailViewController
    weak var detailController: DetailViewController?
    
    weak var delegate: DetailBookmarkDelegate?
    
    // the array that has stuff in it
    var favoritesArray: [[String:AnyObject]]?
    
    // defaults dictionary
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // set self as delegates
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // set favorites array from the defaults dictionary
        favoritesArray = defaults.object(forKey: "favoritesArray") as! [[String:AnyObject]]?

    }
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterTableViewCell", for: indexPath) as! MasterTableViewCell

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
    
    // allows delete or insert to happen
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoritesArray!.remove(at: indexPath.row)
            deleteFavoriteItem(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //update favorites star
            detailController!.checkIfCurrentArticleInFavorites()
            
        } else if editingStyle == .insert {
            // not implementing insert
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObject = favoritesArray![indexPath.row]
        delegate?.bookmarkPassedObject(selectedObject)
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: edit methods
    
    // stuck on how to make editing mode work
    @IBAction func enterEditingMode(_ sender: AnyObject) {
        isEditing = !isEditing
        tableView.setEditing(isEditing, animated: true)
    }
    
    // delete item from bookmarks array
    func deleteFavoriteItem(_ index: Int) -> Void {
        // if defaults has values, add item to bookmarks dictionary
        var array = defaults.object(forKey: "favoritesArray") as! [[String:AnyObject]]?
            
        // append item to array
        array!.remove(at: index)
        
        // re-add the array to nsuserdefaults
        defaults.set(array, forKey: "favoritesArray")
    }
    
}
