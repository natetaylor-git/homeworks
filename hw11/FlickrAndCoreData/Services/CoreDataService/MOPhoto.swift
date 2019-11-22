//
//  MOPhoto.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 22/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit
import CoreData

@objc(MOPhoto)
class MOPhoto: NSManagedObject {
    @NSManaged var id: Int16
    @NSManaged var text: String
    @NSManaged var data: Data
}
