//
//  CoreDataManager.swift
//  Products
//
//  Created by Patricio Benavente on 27/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import CoreData

public class CoreDataManager: NSManagedObject {
	var context: NSManagedObjectContext?
	
	required init(entityName: String){
		let container = NSPersistentContainer(name: "Products")
			container.loadPersistentStores(completionHandler: { (storeDescription, error)in if let error = error as NSError? {
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
		let contextInit: NSManagedObjectContext? = container.viewContext
		let entity = NSEntityDescription.entity(forEntityName: entityName, in: contextInit!)!
		super.init(entity: entity, insertInto: contextInit)
		print("CoreData Initialized…")
		context = contextInit
		
	}
	
	public func fetch<T: NSManagedObject>(_ objectType: T.Type	) -> [T]{
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		do {
			let fetchedObjects = try context?.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? [T]()
		} catch {
			let nserror = error as NSError
			print("Error: \(nserror)")
			//fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			return [T]()
		}
	}
	
	public func save<T: NSManagedObject>(_ objectType: T.Type){
		if context!.hasChanges {
			do {
				try context?.save()
				print("Saved Context: \(objectType.self)")
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	public func saveContext () {
		if context!.hasChanges {
			do {
				try context!.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	public func delete(_ items: [NSManagedObject]?, at indexPath: IndexPath) ->[NSManagedObject]?{
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

	public func deleteAllRecords<T: NSManagedObject>(_ objectType: T.Type)->Bool? {
		let entityName = String(describing: objectType)
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try context!.execute(deleteRequest)
			try context!.save()
			print("All rows delete from \(entityName)")
			return true
		} catch {
			print ("There was an error")
			return false
		}
	}
}
