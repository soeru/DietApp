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
  dynamic var carboIntake: Double = 0.0
  dynamic var proteinIntake: Double = 0.0
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var carboIntakeLabel: UILabel!
  
  var stringItems: [String] = []
  var items: [String] = []
  var itemsSortedByCategory: [ItemsByObject] = []
  var itemsByObject: [ItemsByObject] = []
  var itemsFilteredByCarbo : [ItemsByObject] = []
  var sendText: String = ""
  var carboIntake: Double = 150.0
  var alert:UIAlertController!
//  var intakeRecord = IntakeRecord()
  let settingKey = "carbo_value"
  
  class ItemsByObject {
    var title: String
    var store: String
    var carbo: Double
    var image_url: String
    var category: String
    var protein: Double
    
    init(record: (String, String, Double, String, String, Double)) {
      self.title = record.0
      self.store = record.1
      self.carbo = record.2
      self.image_url = record.3
      self.category = record.4
      self.protein = record.5
    }
    
  }
  
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
        stringItems = csvData.components(separatedBy: "\n")
        if stringItems.last! == "" {
          stringItems.removeLast()
        }
      } catch {
        print(error)
      }
      for stringItem in stringItems {
        items = stringItem.components(separatedBy: ",")
        itemsByObject.append(ItemsByObject(record: (items[0], items[1], Double(items[2])!, items[3], items[4], Double(items[5])!)))
      }
      
      let setting = UserDefaults.standard
      if setting.object(forKey: settingKey) != nil {
        carboIntake = Double(setting.integer(forKey: settingKey))
      }
      
      itemsFilteredByCarbo  = itemsByObject.filter( { $0.carbo < carboIntake } )
      
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(false, animated: true)
    categoryLabel.text = sendText
    carboIntakeLabel.text = "糖質\(Int(carboIntake))g未満"
    switch sendText {
      case "パン":
        for item in itemsFilteredByCarbo  {
          if item.category.contains(sendText) || item.category.contains("サンドイッチ"){
            itemsSortedByCategory.append(item)
          }
      	}
      case "おむすび・お寿司":
        for item in itemsFilteredByCarbo  {
          if item.category.contains("寿司") || item.category.contains("おむすび"){
            itemsSortedByCategory.append(item)
          }
      	}
      case "ドリンク":
        for item in itemsFilteredByCarbo  {
          if item.category.contains("コーヒー・フラッペ"){
            itemsSortedByCategory.append(item)
          }
      }
      case "麺・お弁当":
        for item in itemsFilteredByCarbo  {
          if item.category.contains("パスタ") || item.category.contains("うどん") || item.category.contains("お弁当"){
            itemsSortedByCategory.append(item)
          }
      	}
      case "スープ":
        for item in itemsFilteredByCarbo  {
          if item.title.contains("スープ"){
            itemsSortedByCategory.append(item)
          }
      }
    default:
      for item in itemsFilteredByCarbo  {
        if item.category.contains(sendText) {
          itemsSortedByCategory.append(item)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsSortedByCategory.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
    let itemsDetail = itemsSortedByCategory[indexPath.row]
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
      let itemsDetail = self.itemsSortedByCategory[indexPath.row]
      
//      let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//      Realm.Configuration.defaultConfiguration = config
      
      let df = DateFormatter()
      df.locale = Locale(identifier: "ja_JP")
      df.dateFormat = "yyyy-MM-dd"
      let now = Date()
      
      let intakeRecord = IntakeRecord()
      intakeRecord.id = NSUUID().uuidString
      intakeRecord.recordDate = df.string(from: now)
      intakeRecord.carboIntake = itemsDetail.carbo
      intakeRecord.proteinIntake = itemsDetail.protein
      
      let realm = try! Realm()
      try! realm.write {
        realm.add(intakeRecord, update: true)
      }
//      let result = realm.objects(IntakeRecord.self)
//      print(result)
//      print(intakeRecord)
    })
    let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(recordAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBOutlet weak var categoryLabel: UILabel!

}
