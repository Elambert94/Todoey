//
//  Category.swift
//  Todoey
//
//  Created by Elliott on 01/07/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
