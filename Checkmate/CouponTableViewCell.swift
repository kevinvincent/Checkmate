//
//  CouponTableViewCell.swift
//  Checkmate
//
//  Created by Kevin Vincent on 1/16/16.
//  Copyright © 2016 checkmate. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet var businessName: UILabel!
    @IBOutlet var offerDescription: UILabel!
    
    @IBOutlet var expires: UILabel!
    
    @IBOutlet var backgroundImage: SpringImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
