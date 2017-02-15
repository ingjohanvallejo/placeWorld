//
//  TutorialStep.swift
//  PlacesOfWorld
//
//  Created by Johan Vallejo on 10/11/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import Foundation
import UIKit

class TutorialStep: NSObject {

    var index = 0
    var titleName = ""
    var content = ""
    var image: UIImage!
    
    init(index: Int, titleName: String, content: String, image: UIImage) {

        self.index = index
        self.titleName = titleName
        self.content = content
        self.image = image
    }
}
