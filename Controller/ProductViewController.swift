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
		
		@IBOutlet weak var txtProductPrice: UITextField!
		
		@IBOutlet weak var labelProductCode: UILabel!
		
		@IBAction func barSave(_ sender: UIBarButtonItem) {
			GetDataForSave()
		}
		
		var productCode: String!
		
		//let coreDataManager = CoreDataManager()
		
		private func GetDataForSave()->Void{
			let productName = txtProductName.text ?? ""
			let productPrice = Float(txtProductPrice.text ?? "0")!
			
			if (productName == "") {
				return
			}
		
			let productIdcategory = 1
			saveProduct(productName,productPrice: productPrice, productCode: productCode!,idCategory: productIdcategory)
			
			/*
			let context = coreDataManager.context
			let product = Product(context: context)
			product.code =  "XASSDASDAS12312312"
			product.idcategory = 1
			product.product = productName
			product.sellprice = productPrice
			//coreDataManager.save(Product.self)
			*/
			
			_ = navigationController?.popViewController(animated: true)
		}
		
		private func saveProduct(_ product: String, productPrice: Float,productCode: String, idCategory: Int){
			let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
			let contextProduct = appDelegate.persistentContainer.viewContext
			
			let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: contextProduct )
			newProduct.setValue(product, forKey: "product")
			newProduct.setValue(productCode, forKey: "code")
			newProduct.setValue(productPrice, forKey: "sellprice")
			newProduct.setValue(idCategory, forKey: "idcategory")
			do {
				try contextProduct.save()
				print("Saved Product: \(product)")
				print("Price: \(String(productPrice))")
				dismiss(animated: true, completion: nil)
			}catch{
				print("Error Saving")
			}
		}
		
		override func viewWillDisappear(_ animated: Bool) {
			GetDataForSave()
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			if productCode != nil {
				labelProductCode.text = productCode
			}
			
			self.txtProductName.delegate = self
			self.txtProductPrice.delegate = self
			self.txtProductName.becomeFirstResponder()
		}
		
		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			self.view.endEditing(true)
		}
		
		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			if textField === txtProductName {
				txtProductName.resignFirstResponder()
				txtProductPrice.becomeFirstResponder()
			}else if (textField === txtProductPrice) {
				txtProductPrice.resignFirstResponder()
				GetDataForSave()
			}
			return true
		}
		
		override func prepare(for segue: UIStoryboardSegue, sender: Any?){
			/*
			var destinationVC = segue.destination
			if let navcon = destinationVC as? UINavigationController {
				destinationVC = navcon.visibleViewController ?? destinationVC
			}
			if let newVC = destinationVC as? ProductsTableViewController {
				
			}
			*/
		}
}
