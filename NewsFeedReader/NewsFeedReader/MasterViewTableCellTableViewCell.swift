//
//  MasterViewTableCellTableViewCell.swift
//  NewsFeedReader
//
//  Created by Shuaib Ahmed on 2/21/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    /// MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
