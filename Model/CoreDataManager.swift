//
//  CoreDataManager.swift
//  Products
//
//  Created by Patricio Benavente on 27/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
	
	let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDelegate.persistentContainer.viewContext
	
	func fetch<T: NSManagedObject>(_ objectType: T.Type	) -> [T]{
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
	
	func save<T: NSManagedObject>(_ objectType: T.Type){
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
}
