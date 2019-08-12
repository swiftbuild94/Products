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

	@IBAction func barCancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var textQty: UITextField!
	
	@IBAction func stepper(_ sender: UIStepper) {
		var stepper = 1
		stepper = Int(sender.value)
		textQty.text = String(stepper)
		validateTextQty()
	}
	
	@IBOutlet weak var labelSubtotal: UILabel!
	
	var productCode: String? = nil
	private var productName: String? = nil
	private var qty = 1
	private var productPrice: Float? = nil
//	private var subTotal: Float? = nil
	
	var basketArray:NSMutableArray!
	var plistPath:String!
	
	var plistPathInDocument:String = String()
	
	private func preparePlistForUse(){
		let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
		plistPathInDocument = rootPath.appendingFormat("/basket.plist")
		if !FileManager.default.fileExists(atPath: plistPathInDocument){
			guard let plistPathInBundle = (Bundle.main.path(forResource: "basket", ofType: "plist") ) else { return }
			do {
				try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: plistPathInDocument)
			}catch{
				print("Error occurred while copying file to document \(error)")
			}
		}
	}
	
	private func readPlist(){
		self.preparePlistForUse()
		print("READ PLIST")
//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
			plistPath = plistPathInDocument
			// Extract the content of the file as NSData
		let data:NSData =  FileManager.default.contents(atPath: plistPath)! as NSData
			do{
				basketArray = try PropertyListSerialization.propertyList(from: data as Data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as? NSMutableArray
			}catch{
				print("Error occured while reading from the plist file")
			}
//			self.tableView.reloadData()
		}
	
	
	private func readBasket(){
		print("Try to read basket")
		var productsArrayValues: NSArray!
		let file = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "Basket", ofType: "plist")!)
		let productsArray: NSArray = NSArray.init(object: file!.object(forKey: "Products") as Any)
		productsArrayValues = (productsArray.object(at: 0) as? NSArray)
		for count in 0..<productsArrayValues.count{
			let product = productsArrayValues[count] as? NSDictionary
			print(productsArrayValues[count])
			print(product!.value(forKey: "Name")! )
		}
	}
	
	
	private func writeBasket(){
		print("Write Basket plist")
		let fileManager = FileManager.default
		let newProduct = ["Name":"Tabaco2", "Price":"25,50","Qty":"4","Subtotal":"102"]
		let products = [newProduct]
		let serializedData = try? PropertyListSerialization.data(fromPropertyList: products, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
		let document = try? fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let file = document!.appendingPathComponent("basket.plist")
		do{
			try serializedData!.write(to: file)
			print(document!)
		}catch{
			print(error)
		}
	}

	
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
	
	private func getProductData(){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
		let predicate =  NSPredicate(format: "code == %@", productCode!)
		fetchRequest.predicate = predicate
		do {
			let product = try managedContext.fetch(fetchRequest).first
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

	// MARK: - View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		readPlist()
	}

	
 	override func viewDidLoad() {
        super.viewDidLoad()
		readBasket()
		writeBasket()
		// productCode gets set on segue in ScanViewControler
		if productCode != nil {
			labelProductCode.text = productCode!
			getProductData()
		}
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
