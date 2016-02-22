//
//  Helper.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/22/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation

class Helper {
    static func dateFormatter(dateToBeParsed: String) -> String {
        
        // Turn sample string into nsDateObject
        // - Attributions: http://stackoverflow.com/questions/5185230/converting-an-iso-8601-timestamp-into-an-nsdate-how-does-one-deal-with-the-utc
        
        // - Attributions: http://userguide.icu-project.org/formatparse/datetime got codes from here
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        let nsDateObject = dateFormatter.dateFromString(dateToBeParsed)
        
        // Turn nsDate Object into correctly formatted date string
        // - Attributions: http://nshipster.com/nsformatter/
        // creating NSDateFormatter
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        //output
        let formattedDateString = formatter.stringFromDate(nsDateObject!)
        return formattedDateString
    }
}

