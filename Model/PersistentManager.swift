//
//  PersistentManager.swift
//  Products
//
//  Created by Patricio Benavente on 7/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//


import UIKit
import CoreData

final class PersistentManager: NSObject {
	
	private override init(){}
	static let shared = PersistentManager()
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Products")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	lazy var context = persistentContainer.viewContext
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
				print("Saved Successfully")
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	
}
