//
//  ProductViewController.swift
//  Products
//
//  Created by Patricio Benavente on 11/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

	import UIKit
	import CoreData
	
	class ProductViewController: UIViewController, UITextFieldDelegate {
		
		@IBOutlet weak var txtProductName: UITextField!
		
		@IBAction func cancelNewUser(_ sender: UIBarButtonItem) {
			_ = navigationController?.popViewController(animated: true)
		}
		
		let productCode = "XASSDASDAS12312312"
		let idCategory = 1
		
		@IBAction func barSave(_ sender: UIBarButtonItem) {
			let productName = txtProductName.text ?? ""
			
			if (productName != "") {
				saveProduct(productName,productCode: productCode,idCategory: idCategory)
				_ = navigationController?.popViewController(animated: true)
			}
		}
		
		
		private func saveProduct(_ product: String, productCode: String, idCategory: Int){
			let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
			let contextProduct = appDelegate.persistentContainer.viewContext
			
			let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: contextProduct )
			newProduct.setValue(product, forKey: "product")
			newProduct.setValue(productCode, forKey: "code")
			newProduct.setValue(idCategory, forKey: "idcategory")
			do {
				try contextProduct.save()
				print("Saved Product: \(product)")
				dismiss(animated: true, completion: nil)
			}catch{
				print("Error Saving")
			}
			
		}
		
		/*
		var usersnameArr = [String]()
		var passwordArr = [String]()
		var levelArr = [String]()
		
		private func SearchUser(user: String){
			let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			
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
			let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
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
*/
		
		override func viewDidLoad() {
			super.viewDidLoad()
			
			self.txtProductName.delegate = self
		}
		
		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			self.view.endEditing(true)
		}
		
		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			txtProductName.resignFirstResponder()
			return true
		}
		
}
