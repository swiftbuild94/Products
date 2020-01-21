//
//  Products+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 14/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var adddate: Date?
    @NSManaged public var addusr: Int32
    @NSManaged public var bought_price: Double
    @NSManaged public var editdate: Date?
    @NSManaged public var editusr: Int32
    @NSManaged public var lastsellprice: Double
    @NSManaged public var productcode: Int64
    @NSManaged public var qty: Int16
    @NSManaged public var buy: Buy?
    @NSManaged public var product: Product?
    @NSManaged public var sell: Sell?
    @NSManaged public var storage: Storages?

}
