//
//  Company+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 14/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var address: String?
    @NSManaged public var company: String?
    @NSManaged public var contact: String?
    @NSManaged public var phone: String?
    @NSManaged public var tax_code: String?
    @NSManaged public var buy: NSSet?

}

// MARK: Generated accessors for buy
extension Company {

    @objc(addBuyObject:)
    @NSManaged public func addToBuy(_ value: Buy)

    @objc(removeBuyObject:)
    @NSManaged public func removeFromBuy(_ value: Buy)

    @objc(addBuy:)
    @NSManaged public func addToBuy(_ values: NSSet)

    @objc(removeBuy:)
    @NSManaged public func removeFromBuy(_ values: NSSet)

}
