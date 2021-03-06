//
//  File.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/22/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorView: UIView {

    // initialize the frame
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// called anytime this is added to a superview
    override func didMoveToSuperview() {
        // check if superview exists
        guard (superview != nil) else {
            return
        }
        
        // and create what it looks like
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 5
        
        self.center = self.superview!.center
        
        // add spinner to this
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        spinner.startAnimating()
        spinner.center.x = self.frame.size.width/2
        spinner.center.y = self.frame.size.height/2
        
        // add spinner to square
        self.addSubview(spinner)
    }
}
