//
//  CSVLoader.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/26.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import Foundation

class CSVLoader: NSObject {
	static let sharedInstance = CSVLoader()
	private var items: [Product]?
	
	private var csvItems: [String] = []
	private var strItems: [String] = []
	
	func loadItems() -> Bool {
		// CSVファイル読み込み
		do {
			//CSVファイルのパスを取得する。
			let csvPath = Bundle.main.path(forResource: "fm", ofType: "csv")
			//CSVファイルのデータを取得する。
			let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
			//改行区切りでデータを分割して配列に格納する。
			csvItems = csvData.components(separatedBy: "\n")
			if csvItems.last! == "" {
				csvItems.removeLast()
			}
		} catch {
			print(error)
		}
		
		items = []
		for csvItem in csvItems {
			strItems = csvItem.components(separatedBy: ",")
			let product = Product()
			product.id = Int(strItems[0])!
			product.title = strItems[1]
			product.carbo = Double(strItems[2])!
			product.protein = Double(strItems[3])!
			product.category = strItems[4]
			product.store = strItems[5]
			product.image_url = strItems[6]
			items!.append(product)
			}
		
		if items != nil {
			return true
		} else {
			return false
		}
	}
	
	func getItems() -> [Product]{
		if let items = self.items {
			return items
		}
		if loadItems() {
			return self.items!
		}
		return []
	}
}
