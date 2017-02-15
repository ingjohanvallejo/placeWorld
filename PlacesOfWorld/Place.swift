//
//  Place.swift
//  PlacesOfWorld
//
//  Created by Johan Vallejo on 8/11/16.
//  Copyright © 2016 kijho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Place : NSManagedObject {
    @NSManaged var name : String
    @NSManaged var type : String
    @NSManaged var location : String
    @NSManaged var phone : String?
    @NSManaged var webSite : String?
    @NSManaged var image : NSData?
    @NSManaged var rating : String?
    
 /*   init(name: String, type: String, location: String, phone: String, webSite: String, image: UIImage) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.webSite = webSite
        self.image = image
    }*/
}
