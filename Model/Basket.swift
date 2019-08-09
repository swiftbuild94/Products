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
	
}
