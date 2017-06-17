//
//  GoogleNetworkingManager.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/21/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation
import UIKit

class GoogleNetworkingManager {
    
    // instantiate the singleton
    static let sharedInstance = GoogleNetworkingManager()
    
    // prevent others from instantiating this
    fileprivate init() {}
    
    // func takes a url and a completion block  --> doesn't return anything accept
    // what's in the completion block
    func searchRequest(_ urlString: String, completion: @escaping ([String: AnyObject]?) -> Void) {
        
        /// - Attributions: http://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
        // start networking activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // convert string into an NSURL object
        guard let url = URL(string: urlString)
            else { fatalError("No URL") }
        
        // Create an 'NSURLSession' singleton Object
        let session = URLSession.shared
        
        // Create a task for the session object to complete takes a URL and completion block
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            // Guard against errors during download if exist -> populate the completion block as nil
            guard error == nil else {
                print("error: \(error!.localizedDescription): \(error!._userInfo)")
                completion (nil)
                return
            }
            
            // Print response header (for debugging)
//            print(response)
            
            // Test if data has value else set to nil
            guard let data = data else {
                print("There was no data")
                completion(nil)
                return
            }
            
            // Unserialize the JSON into an Array of Dictionaries and 
            // Pass as parameter to completion block
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let searchResponse = json as? [String: AnyObject] {
                    completion(searchResponse)
                }
            } catch {
                print("error serializing JSON: \(error)")
                completion(nil)
            }
            
            // turn off network activity
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        
        // Start the downloading. NSURLSession objects are created in the paused state, so to start it we need to tell it to resume
        task.resume()
    }
    
}
