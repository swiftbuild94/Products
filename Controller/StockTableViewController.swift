	//
	//  StockTableViewController.swift
	//  Products
	//
	//  Created by Patricio Benavente on 30/05/19.
	//  Copyright © 2019 Patricio Benavente. All rights reserved.
	//
	
	import UIKit
	import CoreData
	
	class StockTableViewController: UITableViewController {
		
		//@IBOutlet weak var tableViewCellProducts: UITableViewCell!
		private var items: [NSManagedObject] = []
		let cellId = "CellStock"
		private var product: Product?
		
		// MARK: - View Lifecycle
		override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
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
			product = Product(context: PersistentManager.context)
			items = (product!.loadProducts()!)
			print(items)
		}
		
		
		// MARK: - Table view data source
		override func numberOfSections(in tableView: UITableView) -> Int {
			// #warning Incomplete implementation, return the number of sections
			return 1
		}
		
		override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			// #warning Incomplete implementation, return the number of rows
			return items.count
		}
		
		override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			//let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
			let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellId)
			
			let item = items[indexPath.row]
			
			let name = item.value(forKey: "product") as? String
			let qty = item.value(forKey: "qty") as? String
			//print("Product: \(name ?? "Error")")
			print("Qty: \(qty ?? "codeError")")
			
			cell.textLabel?.text = name
			cell.detailTextLabel?.text = qty ?? "?" 
			return cell
		}
		
		override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
			let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
				self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
				return
			}
			let moveButton = UITableViewRowAction(style: .destructive, title: "Move") {
				(action, indexPath) in
//				self.tableView.dataSource?.tableView!(tableView, commit: .edit, forRowAt: indexPath)
				return
			}
			deleteButton.backgroundColor = UIColor.red
			moveButton.backgroundColor = UIColor.blue
			return [moveButton]
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
				let context = PersistentManager.context
				context.delete(items[indexPath.row] as NSManagedObject)
				//objects.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
				//Save the object
				
				do{
					try context.save()
					self.loadProducts()
					tableView.reloadData()
				}
				catch let error{
					print("Cannot Save Reason: \(error)")
				}
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
		override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			// Get the new view controller using segue.destination.
			// Pass the selected object to the new view controller.
		}
	}
	
