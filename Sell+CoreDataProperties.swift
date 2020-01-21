//
//  Sell+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 14/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Sell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sell> {
        return NSFetchRequest<Sell>(entityName: "Sell")
    }

    @NSManaged public var selldate: Date?
    @NSManaged public var subtotal: Float
    @NSManaged public var total: Float
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Sell {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Products)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Products)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
