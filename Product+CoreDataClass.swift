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
	private var appDelegate: AppDelegate?
	private var context: NSManagedObjectContext?
	
	convenience init?(appDelegate: AppDelegate?){
		guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
		self.init(entity: Product.entity(), insertInto: context)
		self.appDelegate = appDelegate
		self.context = context
	}
	
	convenience init?(_ appDelegate: AppDelegate?, product: String, code:String, price: Float?, qty: Int?){
		guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
		self.init(entity: Product.entity(), insertInto: context)
		self.product = product
		self.code = code
		self.sellprice = price ?? 0
		self.qty = Int64(qty ?? 1)
	}
	
	func loadProducts()->[NSManagedObject]?{
		let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
		let sort = NSSortDescriptor(key: "product", ascending: true)
		fetchRequest.sortDescriptors = [sort]
		fetchRequest.predicate = NSPredicate(format: "product != nil")
		do {
			return try context!.fetch(fetchRequest)
		} catch let error as NSError {
			print("Failed to Fetch: \(error)")
			return nil
		}
	}
	
	func deleteProduct(_ items: [NSManagedObject]?, at indexPath: IndexPath) ->[NSManagedObject]?{
		guard let contextDelete = appDelegate?.persistentContainer.viewContext else { return nil }
		
		var nsManagedObject = items!
		let productToDelete = items![indexPath.row]
		print("Product to Delete: \(productToDelete)")
		contextDelete.delete(productToDelete)
		do {
			try contextDelete.save()
			nsManagedObject.remove(at: indexPath.row)
			return nsManagedObject
		} catch let error as NSError {
			print("Failed to Delete: \(error)")
			return nil
		}
	}
}
