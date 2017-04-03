//
//  ProductViewController.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/09.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class IntakeRecord: Object{
  dynamic var id: String = ""
  dynamic var recordDate: String = ""
  dynamic var product: Product?
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

class Product: Object {
  dynamic var id: Int = 0
  dynamic var title: String = ""
  dynamic var carbo: Double = 0.0
  dynamic var protein: Double = 0.0
  dynamic var category: String = ""
  dynamic var store: String = ""
  dynamic var image_url: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var carboIntakeLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
	
  var itemsFilteredByCarboLimit : [Product] = []
  var itemsFilteredByCategory: [Product] = []
  var sendText: String = ""
  var carboIntakeLimit: Double = 100.0
  var alert:UIAlertController!
  let settingKey = "carboLimit"
  
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableViewAutomaticDimension
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    categoryLabel.text = sendText
		getCarboIntakeLimit()
		getCSVDataFilteredByCarboLimit()
		getItemsFilteredByCategory(sendText)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsFilteredByCategory.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
    let itemsDetail = itemsFilteredByCategory[indexPath.row]
    cell.titleLabel.text = itemsDetail.title
    cell.storeLabel.text = itemsDetail.store
    cell.carboLabel.text = "糖質 \(itemsDetail.carbo)g"
    let image_url: URL = URL(string: itemsDetail.image_url)!
    cell.productImage.af_setImage(withURL: image_url)
    cell.proteinLabel.text = "タンパク質 \(itemsDetail.protein)g"
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
  }  
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let record = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Record") { (action, indexPath) in
			let df = self.jpDailyDateFormat()
			let now = Date()
			
			let intakeRecord = IntakeRecord()
			intakeRecord.id = NSUUID().uuidString
			intakeRecord.recordDate = df.string(from: now)
			intakeRecord.product = self.itemsFilteredByCategory[indexPath.row]
			
			let realm = try! Realm()
			try! realm.write {
				realm.add(intakeRecord, update: true)
			}
			self.getCarboIntakeLimit()
			self.getCSVDataFilteredByCarboLimit()
			self.getItemsFilteredByCategory(self.sendText)
			self.tableView.reloadData()
			self.alert = UIAlertController(title: "Save", message: "食事を記録しました", preferredStyle: UIAlertControllerStyle.alert)
			self.present(self.alert, animated: true, completion: nil)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
				self.alert.dismiss(animated: true, completion: nil)
			})			
		}
		return [record]
	}
	
	func jpDailyDateFormat() -> DateFormatter {
		let df = DateFormatter()
		df.locale = Locale(identifier: "ja_JP")
		df.dateFormat = "yyyy-MM-dd"
		return df
	}
	
	func getCarboIntakeLimit() {
		let setting = UserDefaults.standard
		if setting.object(forKey: settingKey) != nil {
			carboIntakeLimit = setting.double(forKey: settingKey)
		} else {
			carboIntakeLimit = 100.0
		}
		let realm = try! Realm()
		let now = Date()
		let df = jpDailyDateFormat()
		carboIntakeLimit -= Array(realm.objects(IntakeRecord.self)).filter( { $0.recordDate == df.string(from: now) } ).reduce(0.0, { $0 + $1.product!.carbo})
		if carboIntakeLimit >= 0 {
			carboIntakeLabel.text = "糖質上限:\(Int(floor(carboIntakeLimit)))g"
		} else {
			carboIntakeLabel.text = "糖質上限を\(Int(floor(carboIntakeLimit)) * -1)g超過"
		}
	}
	
	func getCSVDataFilteredByCarboLimit() {
		let loader: CSVLoader = CSVLoader.sharedInstance
		itemsFilteredByCarboLimit  = loader.getItems().filter( { $0.carbo < carboIntakeLimit } )
	}
	
	func getItemsFilteredByCategory(_ category: String) {
		itemsFilteredByCategory = []
		switch category {
		case "パン":
			for item in itemsFilteredByCarboLimit  {
				if item.category.contains(sendText) || item.category.contains("サンドイッチ"){
					itemsFilteredByCategory.append(item)
				}
			}
		case "おむすび":
			for item in itemsFilteredByCarboLimit  {
				if item.category.contains("寿司") || item.category.contains("おむすび"){
					itemsFilteredByCategory.append(item)
				}
			}
		case "ドリンク":
			for item in itemsFilteredByCarboLimit  {
				if item.category.contains("コーヒー・フラッペ"){
					itemsFilteredByCategory.append(item)
				}
			}
		case "麺・お弁当":
			for item in itemsFilteredByCarboLimit  {
				if item.category.contains("パスタ") || item.category.contains("うどん") || item.category.contains("お弁当"){
					itemsFilteredByCategory.append(item)
				}
			}
		case "スープ":
			for item in itemsFilteredByCarboLimit  {
				if item.title.contains("スープ"){
					itemsFilteredByCategory.append(item)
				}
			}
		default:
			for item in itemsFilteredByCarboLimit  {
				if item.category.contains(sendText) {
					itemsFilteredByCategory.append(item)
				}
			}
		}
	}
}
