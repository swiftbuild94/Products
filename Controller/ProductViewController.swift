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
	
	private var productName: String?
	private var productPrice: Float?
	public var product: Product?
	public var productCode: String?
	
	//let coreDataManager = CoreDataManager()
	
	private func GetDataForSave()->Void{
		//	let productName = txtProductName.text ?? ""
		//	let productPrice = Float(txtProductPrice.text ?? "0")!
		//
		product!.product = txtProductName.text ?? ""
		product!.sellprice = Float(txtProductPrice.text ?? "0")!
		//	product.idcategory = 1
		
		if (product?.product == "") {
			return
		}
		saveProduct()
		
		_ = navigationController?.popViewController(animated: true)
	}
	
	private func saveProduct(){
		product = Product(context: PersistentManager.context)
		product!.setValue(self.product?.product, forKey: "product")
		product!.setValue(self.product?.code, forKey: "code")
		product!.setValue(self.product?.sellprice, forKey: "sellprice")
		PersistentManager.save()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
//		GetDataForSave()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("Product View Controller")
		if productCode != nil {
			labelProductCode.text = productCode
			product?.code = productCode!
		}
		print("Product Code: \(productCode ?? "error")")
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
