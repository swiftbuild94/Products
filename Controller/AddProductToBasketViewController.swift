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
		saveBasket()
	}
	
	
	// MARK: - Variables
	var productCode: String? = nil
	private var productName: String? = nil
	private var qty = 1
	private var productPrice: Float? = nil
//	private var subTotal: Float? = nil
	
	var basketArray:NSMutableArray!
	var plistPath:String!
	
	var plistPathInDocument:String = String()
	
	struct Product {
		var id: String
		var name: String
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
	
	
	// MARK: - Plist
	private func preparePlistForUse()->URL?{
		let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, .userDomainMask, true)[0]
		plistPathInDocument = rootPath.appendingFormat("/basket.plist")
		if !FileManager.default.fileExists(atPath: plistPathInDocument){
			guard let plistPathInBundle = (Bundle.main.path(forResource: "basket", ofType: "plist") ) else { return nil}
			do {
				try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: plistPathInDocument)
				let pathURL = URL(fileURLWithPath: plistPathInDocument)
				print(pathURL)
				return pathURL
			}catch{
				print("Error occurred while copying file to document \(error)")
				return nil
			}
		}
	}
	
	private func readBasket(){
		guard let path = preparePlistForUse() else { return }
//		guard let basketPlist = Bundle.main.url(forResource: "Basket", withExtension: "plist") else  { return }
		let basket = NSMutableDictionary(contentsOf: path)
		print("Basket: \(basket.debugDescription)")
		let myDic = NSDictionary(contentsOf: path)
		if let dict = myDic {
			myItemValue = dict.object(forKey: myItemKey) as! String?
			txtValue.text = myItemValue
			
		}
	}
	
	private func saveBasket(){
		
	}
	
	// MARK: - View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		readBasket()
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
