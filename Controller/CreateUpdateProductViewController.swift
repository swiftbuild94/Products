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
		saveProduct()
	}

	public var product: Product?
	public var productCode: String?
	private var productName: String?
	private var productPrice: Float?
	private var productIdCategory: Int?
	private var productQty: Int64?
	private var saving = false
	
	// MARK: - View Lifecycle
	//	override func awakeFromNib() {
	//		super.awakeFromNib()
	//	}
	
	// override func viewWillDisappear(_ animated: Bool) {
	// 		super.viewWillDissappear()
	// 		getDataForSave()
	// }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		existingProduct()
		setup()
	}
	
	private func existingProduct() {
		print("Create Update Product: \(product?.product ?? "NEW")")
		//		print("productCode: \(productCode ?? "value not set")")
		if product != nil {
			productCode = product!.code
			txtProductName.text = product!.product
			txtProductPrice.text = String(product!.sellprice)
			txtQty.text = String(product!.qty)
		}else{
			if productCode != nil && (Int(productCode!) == nil){
				self.txtProductName.placeholder = productCode
			}
		}
		labelProductCode.text = productCode
		print("Product Code: \(productCode ?? "ERROR")")
	}
	
	private func setup() {
		self.txtProductName.delegate = self
		self.txtProductPrice.delegate = self
		self.txtProductName.becomeFirstResponder()
		//Added Toolbar
		addToolbar()
	}
	
	// MARK: - GetData
	private func getDataForSave(){
		productName = txtProductName.text ?? ""
		productPrice = Float(txtProductPrice.text ?? "0")
		productQty = Int64(txtQty.text ?? "1")
		productIdCategory = 1
		print("GetDataForSave2")
		if ((productName == "")||(productPrice == 0)) {
			return
		}
		saveProduct()
	}
	
	
	// MARK: - CoreData
	private func saveProduct(){
		guard let productName = txtProductName.text else { return }
		guard let productPrice = Float(txtProductPrice!.text!) else { return }
		guard let productQty = Int64(txtQty!.text!) else { return }
		if productName == "" { return }
		
		PersistentManager.context.reset()
		product = Product(context: PersistentManager.context)
		product?.product = productName
		product?.code = productCode!
		product?.sellprice = productPrice
		product?.qty = productQty
		if PersistentManager.save() {
			dismiss(animated: true, completion: nil)
		}
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
		self.getDataForSave()
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
			getDataForSave()
		}
		return true
	}
	
}
