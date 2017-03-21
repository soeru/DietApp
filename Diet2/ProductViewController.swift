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
  
  var csvItems: [String] = []
  var items: [String] = []
  var itemsFilteredByCarboLimit : [Product] = []
  var itemsFilteredByCategory: [Product] = []
  var sendText: String = ""
  var carboIntakeLimit: Double = 100.0
  var alert:UIAlertController!
  let settingKey = "carboLimit"
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = UITableViewAutomaticDimension
      
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
//      let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//      Realm.Configuration.defaultConfiguration = config
      
      for csvItem in csvItems {
        items = csvItem.components(separatedBy: ",")
        let product = Product()
        product.id = Int(items[0])!
        product.title = items[1]
        product.carbo = Double(items[2])!
        product.protein = Double(items[3])!
        product.category = items[4]
        product.store = items[5]
        product.image_url = items[6]
        let realm = try! Realm()
        try! realm.write {
          realm.add(product, update: true)
        }
      }
      
      let setting = UserDefaults.standard
      if setting.object(forKey: settingKey) != nil {
        carboIntakeLimit = setting.double(forKey: settingKey)
      }
      
      let realm = try! Realm()
      itemsFilteredByCarboLimit  = realm.objects(Product.self).filter( { $0.carbo < carboIntakeLimit } )
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(false, animated: true)
    categoryLabel.text = sendText
    carboIntakeLabel.text = "糖質\(Int(carboIntakeLimit))g未満"
    switch sendText {
      case "パン":
        for item in itemsFilteredByCarboLimit  {
          if item.category.contains(sendText) || item.category.contains("サンドイッチ"){
            itemsFilteredByCategory.append(item)
          }
      	}
      case "おむすび・お寿司":
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    alert = UIAlertController(title: "食事記録", message: "記録してもいいですか？", preferredStyle: UIAlertControllerStyle.alert)
    let recordAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
      
//      let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//      Realm.Configuration.defaultConfiguration = config
      
      let df = DateFormatter()
      df.locale = Locale(identifier: "ja_JP")
      df.dateFormat = "yyyy-MM-dd"
      let now = Date()
      
      let intakeRecord = IntakeRecord()
      intakeRecord.id = NSUUID().uuidString
      intakeRecord.recordDate = df.string(from: now)
      intakeRecord.product = self.itemsFilteredByCategory[indexPath.row]
      
      let realm = try! Realm()
      try! realm.write {
        realm.add(intakeRecord, update: true)
      }
//      let result = realm.objects(IntakeRecord.self)
//      print(intakeRecord)
//      print(result)
    })
    let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(recordAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }

}
