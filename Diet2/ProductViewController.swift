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
  
  var items: [String] = [
//    (name: "Salad_A", store: "FamilyMart", carbo: "10g", image: "salad"),
//    (name: "Salad_B", store: "Lawson", carbo: "15g", image: "salad"),
//    (name: "Salad_A", store: "Lawson", carbo: "20g", image: "salad")
  ]
  
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
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
    let itemsDetail = items[indexPath.row].components(separatedBy: ",")
    cell.titleLabel.text = itemsDetail[0]
    cell.storeLabel.text = itemsDetail[1]
    cell.carboLabel.text = "糖質 \(itemsDetail[2])g"
    let image_url: URL = URL(string: itemsDetail[3])!
    cell.productImage.af_setImage(withURL: image_url)
    return cell
  }
  
  @IBOutlet weak var categoryLabel: UILabel!
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
