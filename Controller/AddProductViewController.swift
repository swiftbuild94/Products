//
//  AddProductViewController.swift
//  Products
//
//  Created by Patricio Benavente on 11/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController, UITextFieldDelegate {
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
	var productQty: Int64?
	var product: Product?
	
	// MARK: - CoreData
	//let coreDataManager = CoreDataManager()
	
	private func GetDataForSave(){
		productName = txtProductName.text ?? ""
		productPrice = Float(txtProductPrice.text ?? "0")
		productQty = Int64(txtQty.text ?? "1")!
		productIdCategory = 1
		print("GetDataForSave")
		if ((productName == "")||(productPrice == 0)) {
			return
		}
		saveProduct()
	}
	
	private func saveProduct(){
		print("Save Product")
		guard let productName = txtProductName.text else { return }
		guard let productPrice = Float(txtProductPrice!.text!) else { return }
		guard let productQty = Int64(txtQty!.text!) else { return }
		
		PersistentManager.context.reset()
		product = Product(context: PersistentManager.context)
		product?.product = productName
		product?.code = productCode!
		product?.sellprice = productPrice
		product?.qty = productQty
		if PersistentManager.save() {
			performSegue(withIdentifier: "SegueFromNewToBasket", sender: self)
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
		print("Add Product View Controller!")
		if productCode != nil {
			labelProductCode.text = productCode
//			product.code = productCode
			if (Int(productCode!) == nil) {
				self.txtProductName.placeholder = productCode
			}
		}
		print("Product Code: \(productCode ?? "error")")
		setUpKeyboard()
	}
	
	// MARK: - Keyboard
	fileprivate func setUpKeyboard() {
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
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		var destinationvc = segue.destination
		if let navcon = destinationvc as? UINavigationController{
			destinationvc = navcon.visibleViewController ?? destinationvc
		}
		if  let identifier = segue.identifier {
			switch identifier {
				case "SegueFromNewToBasket":
					print("SegueFromNewToBasket: \(String(describing: productCode))")
					if let destinationvc = destinationvc as? AddProductToBasketViewController {
						destinationvc.productCode = productCode
				}
				default:
					break
			}
		}
	}
}
