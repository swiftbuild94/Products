//
//  Product+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 2/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var code: String?
    @NSManaged public var idcategory: Int16
    @NSManaged public var product: String?
    @NSManaged public var sellprice: Float

}
