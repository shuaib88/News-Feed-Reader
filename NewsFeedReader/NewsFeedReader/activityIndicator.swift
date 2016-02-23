//
//  File.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/22/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation
import UIKit

class activityIndicator: UIView {
    
//    // var from DataTable ConliveActivityContainertroller
//    var activityContainer: UIView {
//        /// - Attributions: worked with Dana to define pattern of liveActivity Container and maintain state for closure. See lazy property
//        if let liveActivityContainer = _activityContainer {
//            return liveActivityContainer
//        } else {
//            //create and color a container for indicator
//            let newActivityContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            newActivityContainer.backgroundColor = UIColor.grayColor()
//            newActivityContainer.layer.cornerRadius = 5
//            
////            /// - Attributions: Chaunxi gave me idea to correct for navBar height, I added status Bar
////            // get height of navBar and Status Bar
////            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
////            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
////            
////            // center the new view correcting for top margin
////            newActivityContainer.center.x = tableView.center.x
////            newActivityContainer.center.y = tableView.center.y - navigationBarHeight! - statusBarHeight
//            
////            // center the activity indicator
////            activityIndicator.center.x = newActivityContainer.frame.size.width/2
////            activityIndicator.center.y = newActivityContainer.frame.size.height/2
//            
//            // add subviews
//            newActivityContainer.addSubview(activityIndicator)
//            
//            // makesure it returns the same object
//            _activityContainer = newActivityContainer
//            return _activityContainer!
//        }
//    }
//    
//    // goes hand in hand with the thing
//    var _activityContainer: UIView?
//    
//    // create activity indicator
//    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//    
//    // methods to show it and unshow it
//    self.activityIndicator.startAnimating()
//    self.activityIndicator.stopAnimating()
//    
//    
//    /// view did load
//    // add to views to the view object
//    tableView.addSubview(activityContainer)
//    
//}
}