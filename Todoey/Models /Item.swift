//
//  Item.swift
//  Todoey
//
//  Created by Seun Olalekan on 2021-04-28.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
//    here, the fromType is the type and the propery is the forward property of the relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property:"items")

}


