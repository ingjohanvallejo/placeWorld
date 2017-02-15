//
//  PlaceCell.swift
//  Cooking
//
//  Created by Johan Vallejo on 26/10/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet var imagePlace: UIImageView!
    @IBOutlet var namePlace: UILabel!
    @IBOutlet var typePlace: UILabel!
    @IBOutlet var locationPlace: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
