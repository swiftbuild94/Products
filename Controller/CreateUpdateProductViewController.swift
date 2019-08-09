//
//  CreateUpdateProductViewController
//  Products
//
//  Created by Patricio Benavente on 11/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class CreateUpdateProductViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var txtProductName: UITextField!
	
	@IBOutlet weak var txtProductPrice: UITextField!
	
	@IBOutlet weak var labelProductCode: UILabel!
	
	@IBOutlet weak var txtQty: UITextField!
	
	@IBAction func barSave(_ sender: UIBarButtonItem) {
		GetDataForSave()
	}
	
	var productCode: String?
	var productName: String?
	var productPrice: Float?
	var productIdCategory: Int?
	var productQty: Int?
	var product = Product()
	
	//let coreDataManager = CoreDataManager()
	
	private func GetDataForSave()->Void{
		productName = txtProductName.text ?? ""
		productPrice = Float(txtProductPrice.text ?? "0")
		print("Qty: \(txtQty.text ?? "error")")
		productQty = Int(txtQty.text ?? "1")!
		productIdCategory = 1
		
//		product.product = txtProductName.text ?? ""
//		product.sellprice = Float(txtProductPrice.text ?? "0")!
//		product.idcategory = 1
//
		if ((productName == "")||(productPrice == nil)) {
			return
		}
		saveProduct()
	}
	
	private func saveProduct(){
		let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
		let contextProduct = appDelegate.persistentContainer.viewContext
		
		let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: contextProduct )
		newProduct.setValue(productName, forKey: "product")
		newProduct.setValue(productCode, forKey: "code")
		newProduct.setValue(productPrice, forKey: "sellprice")
		newProduct.setValue(productQty, forKey: "qty")
		newProduct.setValue(productIdCategory, forKey: "idcategory")
		do {
			try contextProduct.save()
			print("Saved Product: \(self.productName!)")
			print("Price: \(String(self.productPrice ?? 0.00))")
			print("Qty: \(String(self.productQty!))")
//			self.navigationController?.popToRootViewController(animated: true)
			dismiss(animated: true, completion: nil)
		}catch{
			print("Error Saving")
		}
	}
	
//	override func awakeFromNib() {
//		super.awakeFromNib()
//	}
	
	override func viewWillDisappear(_ animated: Bool) {
//		GetDataForSave()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("Create Update Product View Controller")
		print("productCode: \(productCode ?? "value not set")")
		if productCode != nil {
			labelProductCode.text = productCode
//			product.code = productCode
			if (Int(productCode!) == nil) {
				self.txtProductName.placeholder = productCode
			}
		}
		print("Product Code: \(productCode ?? "error")")
		self.txtProductName.delegate = self
		self.txtProductPrice.delegate = self
		self.txtProductName.becomeFirstResponder()
		//Added Toolbar
		let ViewForDoneButtonOnKeyboard = UIToolbar()
		let ViewForNextButtonOnKeyboard = UIToolbar()
		ViewForDoneButtonOnKeyboard.sizeToFit()
		ViewForNextButtonOnKeyboard.sizeToFit()
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
		let btnNextOnKeyboard = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.nextKeyboard))
		ViewForDoneButtonOnKeyboard.items = [space, btnDoneOnKeyboard]
		ViewForNextButtonOnKeyboard.items = [space, btnNextOnKeyboard]
		txtProductPrice.inputAccessoryView = ViewForNextButtonOnKeyboard
		txtQty.inputAccessoryView = ViewForDoneButtonOnKeyboard
	}
	
	@objc func nextKeyboard()  {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		txtProductPrice.resignFirstResponder()
		txtQty.becomeFirstResponder()
	}
	
	@objc func dismissKeyboard()  {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		self.GetDataForSave()
		self.view.endEditing(true)
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
			txtQty.becomeFirstResponder()
		}else if (textField === txtQty){
			txtQty.resignFirstResponder()
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