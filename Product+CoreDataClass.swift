//
//  Product+CoreDataProperties.swift
//  Products
//
//  Created by Patricio Benavente on 13/01/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
//

import CoreData

public class Product: NSManagedObject {
	convenience init(product: String, code:String, price: Float?, qty: Int?){
		self.init(context: PersistentManager.context)
		self.product = product
		self.code = code
		self.sellprice = price ?? 0
		self.qty = Int64(qty ?? 1)
//		PersistentManager.save()
	}
	
	func loadProducts()->[NSManagedObject]?{
		let items = PersistentManager.fetch(Product.self, sortBy: "product", predicate: "product !=nil") as [NSManagedObject]
		return items
	}
	
	func createUpdate(){
		let _ = PersistentManager.save()
	}
	
	func delete(_ items: [NSManagedObject]?, at indexPath: IndexPath) ->[NSManagedObject]?{
		var nsManagedObject = items!
		let productToDelete = items![indexPath.row]
		guard let contextDelete = productToDelete.managedObjectContext else { return nil }
		
		print("Product to Delete: \(productToDelete)")
		contextDelete.delete(productToDelete)
		do {
			try contextDelete.save()
			nsManagedObject.remove(at: indexPath.row)
			print("Product Deleted")
			return nsManagedObject
		} catch let error as NSError {
			print("Failed to Delete: \(error)")
			return nil
		}
	}
}
