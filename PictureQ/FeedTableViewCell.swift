//
//  FeedTableViewCell.swift
//  PictureQ
//
//  Created by jpk on 6/19/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageFromRails: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
