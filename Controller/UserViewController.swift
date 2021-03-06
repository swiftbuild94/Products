//
//  UserViewController.swift
//  Products
//
//  Created by Patricio Benavente on 24/03/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
	
	@IBOutlet weak var txtUser: UITextField!
	@IBOutlet weak var txtPassword: UITextField!
	@IBOutlet weak var txtRetypePass: UITextField!
	
	let txtLevel = "1"
	
	@IBAction func cancelNewUser(_ sender: UIBarButtonItem) {
		_ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func barSave(_ sender: UIBarButtonItem) {
		let user = txtUser.text ?? ""
		let password = txtPassword.text ?? ""
		if ((user != "") && (password != "")){
			saveUser(user, password: password,level: txtLevel)
			//_ = navigationController?.popViewController(animated: true)
		}
	}
	
	
	private func saveUser(_ user: String, password: String, level: String){
//		user = User(context: PersistentManager.context)
//		user.setValue(user, forKey: "username")
//		user.setValue(password, forKey: "password")
//		user.setValue(level, forKey: "level")
//		PersistentManager.save()
	}
	
	var usersnameArr = [String]()
	var passwordArr = [String]()
	var levelArr = [String]()
	
	private func SearchUser(user: String){
		let context = PersistentManager.context
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
		request.returnsObjectsAsFaults = false
		request.predicate = NSPredicate(format: "username=%@", ""+user)
		
		do{
			let results = try context.fetch(request)
			if results.count > 0 {
				for result in results as! [NSManagedObject]{
					if let username = result.value(forKey: "username") as? String {
						print(username)
						usersnameArr.append(username)
					}
					if let password = result.value(forKey: "password") as? String {
						print(password)
						passwordArr.append(password)
					}
					if let level = result.value(forKey: "level") as? String {
						print(level)
						levelArr.append(level)
					}
				}
			}else{
				print("Not Found")
			}
		}catch{
			print("Error Searching")
		}
	}
	
	private func getUser(){
		let context = PersistentManager.context
		//let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
		request.returnsObjectsAsFaults = false
		//var results: NSArray = context.executeFetchRequest(request, error: nil)
		do{
			let results = try context.fetch(request)
			
			if results.count > 0 {
				for result in results as! [NSManagedObject]{
					if let username = result.value(forKey: "username") as? String {
						print(username)
						usersnameArr.append(username)
					}
					if let password = result.value(forKey: "password") as? String {
						print(password)
						passwordArr.append(password)
					}
					if let level = result.value(forKey: "level") as? String {
						print(level)
						levelArr.append(level)
					}
				}
			}
		}catch{
			print("Error Retriving")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
