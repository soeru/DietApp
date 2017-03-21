//
//  RecordViewController.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/19.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var intakeRecord: [IntakeRecord] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let realm = try! Realm()
    intakeRecord = Array(realm.objects(IntakeRecord.self))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func sectionDate(_ section: Int) -> Date {
    let now = Date()
    let duration = -60*60*24*section
    let date = Date(timeInterval: TimeInterval(duration), since: now)
    return date
  }
  
  func jpDailyDateFormat() -> DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ja_JP")
    df.dateFormat = "yyyy-MM-dd"
    return df
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let df = jpDailyDateFormat()
    return df.string(from: sectionDate(section))
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    let recordRetentionPeriod = 14
    return recordRetentionPeriod
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let df = jpDailyDateFormat()
    return intakeRecord.filter( { $0.recordDate == df.string(from: sectionDate(section))} ).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
    let df = jpDailyDateFormat()
    let intakeRecordFilteredByDate = intakeRecord.filter( { $0.recordDate == df.string(from: sectionDate(indexPath.section))} )
    let intakeRecordItem = intakeRecordFilteredByDate[indexPath.row]
    cell.titleLabel.text = intakeRecordItem.product?.title
    cell.storeLabel.text = intakeRecordItem.product?.store
    cell.carboLabel.text = "糖質 \(intakeRecordItem.product!.carbo)g"
    let image_url = URL(string: (intakeRecordItem.product?.image_url)!)!
    cell.productImage.af_setImage(withURL: image_url)
    cell.proteinLabel.text = "タンパク質 \(intakeRecordItem.product!.protein)g"
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
  }
}
