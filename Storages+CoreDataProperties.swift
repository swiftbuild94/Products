//
//  Storages+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 14/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Storages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Storages> {
        return NSFetchRequest<Storages>(entityName: "Storages")
    }

    @NSManaged public var storage: String?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Storages {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Products)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Products)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
