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
		print("Save Button Pressed")
		GetDataForSave()
	}

	public var product: Product?
	public var productCode: String?
	private var productName: String?
	private var productPrice: Float?
	private var productIdCategory: Int?
	private var productQty: Int?
	
	
	// MARK: - GetData
	private func GetDataForSave(){
		print("GetDataForSave")
		guard let name = txtProductName.text else { return }
		guard let strPrice = txtProductPrice.text else { return }
		guard let price = Float(strPrice) else { return }
		
		productQty = Int(txtQty.text ?? "1")
		productName = name
		productPrice = Float(price)
		print("ProductName: \(String(describing: productName))")
		print("ProductPrice: \(String(describing: productPrice))")
		print("Qty: \(txtQty.text ?? "error")")
		saveProduct()
	}
	
	
	// MARK: - CoreData
	private func saveProduct(){
		print("CreateUpdateProduct->saveProduct")
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		let newProduct = Product(appDelegate, product: productName!, code: productCode!, price: productPrice, qty: productQty)
		do {
			try newProduct?.managedObjectContext?.save()
			print("Saved Product: \(String(describing: productName!))")
			performSegue(withIdentifier: "unwindToProductsTable", sender: self)
		} catch {
			print(error)
		}

	}
	
	
	// MARK: - View Lifecycle
//	override func awakeFromNib() {
//		super.awakeFromNib()
//	}
	
	override func viewWillDisappear(_ animated: Bool) {
//		GetDataForSave()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("Create Update Product View Controller2")
//		print("productCode: \(productCode ?? "value not set")")
		if productCode != nil {
			labelProductCode.text = productCode
			if (Int(productCode!) == nil) {
				self.txtProductName.placeholder = productCode
			}
		}
		print("Product Code: \(productCode ?? "error")")
		self.txtProductName.delegate = self
		self.txtProductPrice.delegate = self
		self.txtProductName.becomeFirstResponder()
		//Added Toolbar
		addToolbar()
	}
	
	// MARK: - Toolbar
	func addToolbar(){
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
	
	
	// MARK: - Keyboard
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
	
	
	// MARK: - Navigation
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
