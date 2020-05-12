//
//  PersistentManager.swift
//  Products
//
//  Created by Patricio Benavente on 7/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//


import Foundation
import CoreData

final class PersistentManager {
	
	init(){}
	
	static var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
//	public var context2: NSManagedObjectContext {
//		let container = NSPersistentContainer(name: "Products")
//		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//			if let error = error as NSError? {
//				fatalError("Unresolved error \(error), \(error.userInfo)")
//			}
//		})
//		   return container.viewContext
//	   }
	
	static var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Products")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	
	static func fetch<T: NSManagedObject>(_ objectType: T.Type, sortBy: String? = nil, predicate: String? = nil) -> [T]{
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		if sortBy != nil {
			let sort = NSSortDescriptor(key: sortBy!, ascending: true)
			fetchRequest.sortDescriptors = [sort]
		}
		if predicate != nil {
			fetchRequest.predicate = NSPredicate(format: predicate!)
		}
		
		do {
			let fetchedObjects = try context.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? [T]()
		} catch {
			let nserror = error as NSError
			print("Error: \(nserror)")
			//fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			return [T]()
		}
	}
	
	static func save()->Bool {
		if context.hasChanges {
			do {
				try context.save()
				print("SAVED")
				return true
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
		return false
	}
	
	
	static func delete(_ items: [NSManagedObject]?, at indexPath: IndexPath) ->[NSManagedObject]?{
		var nsManagedObject = items!
		let productToDelete = items![indexPath.row]
		guard let contextDelete = productToDelete.managedObjectContext else { return nil }

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
	
	static func deleteAllRecords<T: NSManagedObject>(_ objectType: T.Type){
		let entityName = String(describing: objectType)
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try context.execute(deleteRequest)
			try context.save()
			print("All rows delete from \(entityName)")
		} catch {
			print ("There was an error")
		}
	}
	
}
