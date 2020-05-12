//
//  AddProductToBasketViewController.swift
//  Products
//
//  Created by Patricio Benavente on 29/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class AddProductToBasketViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var labelProductName: UILabel!
	@IBOutlet weak var labelProductPrice: UILabel!
	@IBOutlet weak var labelProductCode: UILabel!
	@IBOutlet weak var textQty: UITextField!
	@IBOutlet weak var labelSubtotal: UILabel!
	@IBAction func stepper(_ sender: UIStepper) {
		var stepper = 1
		stepper = Int(sender.value)
		textQty.text = String(stepper)
		validateTextQty()
	}
	@IBAction func barCancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func BasketButton(_ sender: UIBarButtonItem) {
		let subTotal: Float = (productPrice ?? 0) * Float(qty)
		let newProduct = Product(id: productId!, name: productName!, code: productCode!, price: productPrice!, qty: qty, subTotal: subTotal)
		print("HERE")
		saveBasket("Basket", value: newProduct)
	}
	
	// MARK: - Variables
	public var productCode: String? = nil
	public var productId: Int? = nil
	private var productName: String? = nil
	private var qty = 1
	private var productPrice: Float? = nil
//	private var subTotal: Float? = nil
	
	var basketArray:NSMutableArray!
	var plistPath:String!
	
	var plistPathInDocument:String = String()
	
	struct Product {
		var id: Int
		var name: String
		var code: String
		var price: Float
		var qty: Int
		var subTotal: Float
	}
	
	struct Basket {
		var date: Date
		var total: Float
		var products = [Product].self
	}
	
	var basket: Basket?
//	var product: NSMutableDictionary?
	
	// MARK: - Processing Qty & Subtotal
	private func validateTextQty(){
		if ((textQty.text != nil) && (textQty.text != "")){
			if (Int(textQty.text!) != nil) {
				textQty.placeholder = textQty.text
				qty = Int(textQty.text!)!
				self.setSubtotal()
			}
		}
	}
	
	private func updateViewSubTotal(_ qty: Int, subTotal: Float ){
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		let strSubTotal = numberFormatter.string(from: subTotal as NSNumber)!
		labelSubtotal.text = strSubTotal
	}
	
	private func setSubtotal(){
		let subTotal: Float = (productPrice ?? 0) * Float(qty)
		updateViewSubTotal(qty, subTotal: subTotal)
	}
	
	// MARK: - CoreData
	private func getProductData(){
		let context = PersistentManager.context
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
		let predicate =  NSPredicate(format: "code == %@", productCode!)
		fetchRequest.predicate = predicate
		do {
			let product = try context.fetch(fetchRequest).first
			if product == nil { return    }
			productName = product!.value(forKey: "product") as? String
			productPrice = product!.value(forKey: "sellprice") as? Float
			
			let numberFormatter = NumberFormatter()
			numberFormatter.numberStyle = .currency
			let strProductPrice = numberFormatter.string(from: (productPrice ?? 0) as NSNumber)
			
			labelSubtotal.text = strProductPrice
			labelProductName.text = productName
			labelProductPrice.text = strProductPrice
			qty = 1
			setSubtotal()
		} catch let error as NSError {
			print("Failed to Fetch: \(error)")
		}
	}
	
	
	// MARK: - Plist
	private func readPlist(_ fileName: String){
		let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as NSArray
		let documentDirectory = paths[0] as! String
		let path = documentDirectory.appending("/"+fileName+".plist")
		print(path)
		let fileManager = FileManager.default
		if (!fileManager.fileExists(atPath: path)){
			if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist") {
				print(bundlePath)
				guard let result = NSMutableDictionary(contentsOfFile: bundlePath) else { return }
				print("Bundle file: \(result)")
				print(result["Total"] ?? "Error")
				do {
					try fileManager.copyItem(atPath: bundlePath, toPath: path)
				} catch {
					print("Copy Failure")
				}
			} else {
				print("File Not Found")
			}
		} else {
			if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist"){
				print(bundlePath)
				guard let resultDictionary = NSMutableDictionary(contentsOfFile: path) else { return }
				print("Bundle file: \(resultDictionary)")
				print(resultDictionary["Total"] ?? "Error")
				guard let products = resultDictionary["Products"] as? NSMutableArray else { return }
				guard let firstProduct = products[0] as? NSMutableDictionary else { return }
				let nameProduct = firstProduct["Name"]
				print("Name: \(nameProduct ?? "Error Products")")
			}
		}
	}
	
	private func saveBasket(_ fileName: String, value: Product){
		print("SAVE Basket")
		let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as NSArray
		let documentDirectory = paths[0] as! String
		let path = documentDirectory.appending("/"+fileName+".plist")
		print("Product to add to basket: \(value)")
		let newDictionary: NSMutableDictionary = [:]
		newDictionary.setValue(value, forKey: "Products")
		newDictionary.write(toFile: path, atomically: false)
		print("Saved")
	}
	
	
	// MARK: - View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
//		readPlist("Basket")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
//		readBasket()
//		writeBasket()
		// productCode gets set on segue in ScanViewControler
		if productCode != nil {
			labelProductCode.text = productCode!
			getProductData()
		}
		setUpKeyboard()
	}
	
	// MARK: - Keyboard
	fileprivate func setUpKeyboard() {
		textQty.becomeFirstResponder()
		textQty.clearsOnBeginEditing = true
		
		//Check on Change
		textQty.delegate = self
		textQty.addTarget(self, action: #selector(textIsChanging), for: UIControl.Event.editingChanged)
		
		// Added Toolbar with Done button
		let ViewForDoneButtonOnKeyboard = UIToolbar()
		ViewForDoneButtonOnKeyboard.sizeToFit()
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
		ViewForDoneButtonOnKeyboard.items = [space, btnDoneOnKeyboard]
		textQty.inputAccessoryView = ViewForDoneButtonOnKeyboard
	}
	
	@objc func dismissKeyboard()  {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		self.validateTextQty()
		self.view.endEditing(true)
	}
	
	@objc func textIsChanging(_ textField:UITextField) {
		self.validateTextQty()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		validateTextQty()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === textQty {
			textQty.resignFirstResponder()
			validateTextQty()
		}
		return true
	}

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
