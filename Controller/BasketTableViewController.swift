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
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
		let sort = NSSortDescriptor(key: "product", ascending: true)
		fetchRequest.sortDescriptors = [sort]
		do {
			items = try managedContext.fetch(fetchRequest)
			//items.forEach({ print ($0.value(forKey: "product")!) })
			
		} catch let error as NSError {
			print("Failed to Fetch: \(error)")
		}
	}
	
	
	private func preparePlistForUse(){
		print("PreparePlistForUse2")
		let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
		plistPathInDocument = rootPath.appendingFormat("/Basket.plist")
		print(plistPathInDocument)
		if !FileManager.default.fileExists(atPath: plistPathInDocument){
			guard let plistPathInBundle = (Bundle.main.path(forResource: "Basket", ofType: "plist") ) else {
				print("Error Coping")
				return }
			do {
				try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: plistPathInDocument)
				print(plistPathInDocument)
				print("File succesfully copied")
			}catch{
				print("Error occurred while copying file to document \(error)")
			}
		}else {
			print("Out")
		}
	}
	
	
	private func readBasket(){
		self.preparePlistForUse()
		plistPath = plistPathInDocument
		print("Plist: \(plistPath ?? "plist is nil")")
		guard let temp = plistPath else { return }
		do {
			let data :NSData = try NSData(contentsOfFile: temp)
			basketArray = try! PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil) as! [String:Any]
//			for count in 0..<basketArray!.count{
//				let product = basketArray![count] as? NSDictionary
//				print(basketArray![count])
//				print(product!.value(forKey: "Name")! )
//			}
			print(basketArray.self!)
		} catch {
			print(error)
		}
		self.tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		readBasket()
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
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
			let context = appDelegate.persistentContainer.viewContext
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
