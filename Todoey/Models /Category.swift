//
//  Category.swift
//  Todoey
//
//  Created by Seun Olalekan on 2021-04-28.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorBackground: String = ""
    let items = List<Item>()
}
