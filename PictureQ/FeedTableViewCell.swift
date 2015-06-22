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
    @IBOutlet weak var userNameForCell: UILabel!
    @IBOutlet weak var solvedForCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageFromRails.layer.cornerRadius = CGFloat(10)
        imageFromRails.clipsToBounds = true
    
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
