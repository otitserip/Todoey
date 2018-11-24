//
//  Category.swift
//  Todoey
//
//  Created by Tito Pires on 23/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""

    //para a relationship
    let items = List<Item>()
    
    
}
