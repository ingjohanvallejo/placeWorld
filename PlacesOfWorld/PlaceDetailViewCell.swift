//
//  PlaceDetailViewCell.swift
//  Cooking
//
//  Created by Johan Vallejo on 27/10/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import UIKit

class PlaceDetailViewCell: UITableViewCell {

    @IBOutlet var keyNameDetail: UILabel!
    @IBOutlet var nameDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
