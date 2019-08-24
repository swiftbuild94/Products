//
//  Basket.swift
//  Products
//
//  Created by Patricio Benavente on 6/07/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit

struct Basket: Codable {
	let id: Int
	let name: String
	let price: Float
	let qty: Int
	let subTotal: Float
	let items: String
	let Products: Basket_Products
	let Date: Date
	let total: Float
}

struct Basket_Products: Codable {
	let id: Int
	let name: String
	let price: Float
	let qty: Int
	let subTotal: Float
}


struct BasketValues {
	static func get()->Basket? {
		guard let url = Bundle.main.url(forResource: "Basket", withExtension: "plist") else {
			fatalError("Could not find Basket file in bundle")
		}
		do {
			let data = try Data(contentsOf: url)
			let decoder = PropertyListDecoder()
			return try decoder.decode(Basket.self, from: data)
		} catch let err {
			print(err.localizedDescription)
			return nil
		}
	}
	static func getPlist(withName name: String) -> [String]? {
		if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
			let xml = FileManager.default.contents(atPath: path) {
			return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
		}
		return nil
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
	
	
}
