//
//  Product+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 13/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import CoreData
import UIKit

public class Product: NSManagedObject {
	
	convenience init?(product: String, code:String, price: Float?, qty: Int?){
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
		self.init(entity: Product.entity(), insertInto: context)
		self.product = product
		self.code = code
		self.sellprice = price ?? 0
		self.qty = Int64(qty ?? 1)
	}
	
}
