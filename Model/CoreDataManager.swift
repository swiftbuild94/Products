//
//  CoreDataManager.swift
//  Products
//
//  Created by Patricio Benavente on 27/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataManager: NSManagedObject {
	
	private let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
	public lazy var context = appDelegate.persistentContainer.viewContext
	
	public func deleteAllRecords<T: NSManagedObject>(_ objectType: T.Type)->Bool? {
//		let appDelegate = UIApplication.shared.delegate as? AppDelegate
//		guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
		let entityName = String(describing: objectType)
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try context.execute(deleteRequest)
			try context.save()
			print("All rows delete from \(entityName)")
			return true
		} catch {
			print ("There was an error")
			return false
		}
	}
	
	public func fetch<T: NSManagedObject>(_ objectType: T.Type	) -> [T]{
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
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
	
	public func save<T: NSManagedObject>(_ objectType: T.Type){
		if context.hasChanges {
			do {
				try context.save()
				print("Saved Context: \(objectType.self)")
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	public func saveContext () {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
