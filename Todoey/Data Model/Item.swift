//
//  Item.swift
//  Todoey
//
//  Created by Tito Pires on 23/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var data : Date = Date()

    //para a relationship
    var parentCategory =  LinkingObjects(fromType: Category.self, property: "items")
    
}
