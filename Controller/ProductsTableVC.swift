//
//  ProductsTableVC.swift
//  Products
//
//  Created by Patricio Benavente on 6/02/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableVC: UITableViewController {
	
	private var items: [NSManagedObject]?
	private let cellId = "CellProducts"
	private var product: Product?
	private var productEditing = false
	private var passTruProduct: Product?
	private var selectedName: String?
	
	@IBAction func backButton(_ sender: UIBarButtonItem) {
		print("Back")
		self.dismiss(animated: true, completion: nil)
	}
	
	
	// MARK: - View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("ProductsTableVC")
		self.loadProducts()
		self.tableView.reloadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		//self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	
	// MARK: - CoreData
	private func loadProducts(){
		product = Product()
		items = product?.loadProducts()
	}
	
	private func editProduct(at indexPath: IndexPath){
		passTruProduct = items![indexPath.row] as? Product
		productEditing = true
	}
	
	private func deleteProduct(at indexPath: IndexPath){
		let ns: [NSManagedObject]? = product?.delete(items, at: indexPath)
		if ns != nil {
			items = ns
			tableView.deleteRows(at: [indexPath], with: .automatic)
			self.loadProducts()
			self.tableView.reloadData()
			print("Deleted")
		} else {
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
	
	
	// MARK: - Alert
	private func alertDelete(at indexPath: IndexPath){
		let item = items![indexPath.row]
		let name = item.value(forKey: "product") as? String
		
		let alert = UIAlertController(title: "Delete Product \(String(describing: name!))", message: "Are you sure you want to delete the product \(String(describing: name!))", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
			self.deleteProduct(at: indexPath)
			print ("Alert: Yes")
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
			print("Alert: Cancel")
		}))
		present(alert, animated: true, completion: nil)
	}
	
	
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return items!.count
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
		selectedName = cell?.textLabel?.text
		print("selectedName: \(selectedName!)")
		//		let selectedRow = tableView.indexPathForSelectedRow!.row
		let selectedRow = tableView.indexPath(for: cell!)!.row
		passTruProduct = items![selectedRow] as? Product
		print("SegueEditProduct")
		self.performSegue(withIdentifier: "SegueEditProduct", sender: self)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellId)
		
		let item = items![indexPath.row]
		
		let name = item.value(forKey: "product") as? String
		let sellPrice = item.value(forKey: "sellprice") as? Float
		//print("Product: \(name ?? "Error")")
//		print("sellPrice: \(sellPrice ?? "codeError")")
		
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		let stringSellPrice = numberFormatter.string(from: (sellPrice ?? 0) as NSNumber)!
		
		cell.textLabel?.text = name
		cell.detailTextLabel?.text = stringSellPrice
		return cell
	}
	
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
			return
		}
		
		deleteButton.backgroundColor = UIColor.red
//		moveButton.backgroundColor = UIColor.blue
		return [deleteButton]
	}
	
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			alertDelete(at: indexPath)
		}
	}
	
	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
	
	}
	*/
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the item to be re-orderable.
	return true
	}
	*/
	
	
	// MARK: - Keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	
	// MARK: - Navigation
	@IBAction func unwindToProductsTable(_ sender: UIStoryboardSegue){
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		var destinationvc = segue.destination
		if let navcon = destinationvc as? UINavigationController{
			destinationvc = navcon.visibleViewController ?? destinationvc
		}
		if  let identifier = segue.identifier {
			switch identifier {
				case "SegueEditProduct":
					if productEditing {
						if let destinationvc = destinationvc as? CreateUpdateProductViewController {
							destinationvc.title = "Edit Product: " + passTruProduct!.product.capitalized
							destinationvc.product = passTruProduct
						}
				}
				default:
					break
			}
		}
	}
}
