//
//  DetailBookmarkDelegate.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/22/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation

protocol DetailBookmarkDelegate: class {
    func bookmakPassedURL(url: String) -> Void
}
