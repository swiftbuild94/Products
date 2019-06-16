//
//  AddProductToBasketViewController.swift
//  Products
//
//  Created by Patricio Benavente on 29/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class AddProductToBasketViewController: UIViewController {

	@IBOutlet weak var labelProductName: UILabel!
	
	@IBOutlet weak var labelProductPrice: UILabel!
	
	@IBOutlet weak var labelProductCode: UILabel!

	@IBAction func barCancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var textQty: UITextField!{
		didSet{
			setSubtotal()
		}
	}
	
	@IBAction func stepper(_ sender: UIStepper) {
		textQty.text = String(Int(sender.value))
		setSubtotal()
	}
	
	@IBOutlet weak var labelSubtotal: UILabel!
	
	var productCode: String? = nil
	private var productName: String? = nil
	private var qty = 1
	private var productPrice: Float? = nil
//	private var subTotal: Float? = nil
	
	
	func updateViewSubTotal(_ qty: Int, subTotal: Float ){
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		let strSubTotal = numberFormatter.string(from: subTotal as NSNumber)!
		labelSubtotal.text = strSubTotal
	}
	private func setSubtotal(){
		qty = Int(textQty.text!)!
		//#TODO Validate is Int
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
			setSubtotal()
		} catch let error as NSError {
			print("Failed to Fetch: \(error)")
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		// productCode gets set on segue in ScanViewControler
		if productCode != nil {
			labelProductCode.text = productCode!
			getProductData()
		}
		textQty.becomeFirstResponder()
		textQty.clearsOnBeginEditing = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		setSubtotal()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === textQty {
			textQty.resignFirstResponder()
			setSubtotal()
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
