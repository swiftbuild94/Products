//
//  BasketTableViewController.swift
//  Products
//
//  Created by Patricio Benavente on 25/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class BasketTableViewController: UITableViewController {

	let cellId = "CellBasket"
	var basketArray: [String:Any]?
	var plistPath:String?
	
	var plistPathInDocument:String = String()
	
	private var items: [NSManagedObject] = []
	private func loadProducts(){
		let context = PersistentManager.context
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
		let sort = NSSortDescriptor(key: "product", ascending: true)
		fetchRequest.sortDescriptors = [sort]
		do {
			items = try context.fetch(fetchRequest)
			//items.forEach({ print ($0.value(forKey: "product")!) })
			
		} catch let error as NSError {
			print("Failed to Fetch: \(error)")
		}
	}
	
	
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		readPlist("Basket")
//		self.loadProducts()
		self.tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

	override func tableView(_ tableView: UITableView,
							numberOfRowsInSection section: Int) -> Int{
//		print(basketArray!.count)
//		return basketArray!.count
		return items.count
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellId)
//		cell.textLabel!.text = basketArray?.object(at: indexPath.row) as? String
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellId)
		
		let item = items[indexPath.row]
		
		let name = item.value(forKey: "product") as? String
		let qty = item.value(forKey: "qty") as? String
		//print("Product: \(name ?? "Error")")
		print("Qty: \(qty ?? "codeError")")
		
		cell.textLabel?.text = name
		cell.detailTextLabel?.text = qty ?? "1"
		return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			let context = PersistentManager.context
//			context.delete(basketArray[indexPath.row] as NSManagedObject)
			//objects.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			//Save the object
			
			do{
				try context.save()
//				self.loadProducts()
				tableView.reloadData()
			}
			catch let error{
				print("Cannot Save: Reason: \(error)")
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
