//
//  Buy+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 14/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Buy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Buy> {
        return NSFetchRequest<Buy>(entityName: "Buy")
    }

    @NSManaged public var invoice: Int32
    @NSManaged public var subtotal: Double
    @NSManaged public var tax: Double
    @NSManaged public var total: Double
    @NSManaged public var company: Company?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Buy {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Products)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Products)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
