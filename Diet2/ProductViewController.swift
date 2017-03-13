//
//  ProductViewController.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/09.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var items: [String] = []
  var sortedItems: [String] = []
  
  var sendText: String = ""
  
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
        items = csvData.components(separatedBy: "\n")
        if items.last! == "" {
          items.removeLast()
        }
      } catch {
        print(error)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    categoryLabel.text = sendText
    switch sendText {
      case "パン":
        for item in items {
          if item.contains(sendText) || item.contains("サンドイッチ"){
            sortedItems.append(item)
          }
      	}
      case "おむすび・お寿司":
        for item in items {
          if item.contains("寿司") || item.contains("おむすび"){
            sortedItems.append(item)
          }
      	}
      case "ドリンク":
        for item in items {
          if item.contains("コーヒー・フラッペ"){
            sortedItems.append(item)
          }
      }
      case "麺・お弁当":
        for item in items {
          if item.contains("パスタ") || item.contains("うどん") || item.contains("お弁当"){
            sortedItems.append(item)
          }
      	}
    default:
      for item in items {
        if item.contains(sendText) {
          sortedItems.append(item)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
    let itemsDetail = sortedItems[indexPath.row].components(separatedBy: ",")
    cell.titleLabel.text = itemsDetail[0]
    cell.storeLabel.text = itemsDetail[1]
    cell.carboLabel.text = "糖質 \(itemsDetail[2])g"
    let image_url: URL = URL(string: itemsDetail[3])!
    cell.productImage.af_setImage(withURL: image_url)
    return cell
  }
  
  @IBOutlet weak var categoryLabel: UILabel!

}
