//
//  NewUserViewController.swift
//  Products
//
//  Created by Patricio Benavente on 24/03/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
	
	@IBAction func txtUser(_ sender: UITextField) {
	}
	
	@IBAction func txtPassword(_ sender: UITextField) {
	}
	
	@IBAction func txtRetypePass(_ sender: UITextField) {
	}
	
	@IBAction func btnSave(_ sender: UIButton) {
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Storing CoreData
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
	}
	
	
}

