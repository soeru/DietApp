//
//  ViewController.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/09.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  let category: [(header: String, imageLeft: String, imageCenter: String, imageRight: String, categoryLeft: String, categoryCenter: String, categoryRight: String)] = [
    (header: "ヘルシー", imageLeft: "salad", imageCenter: "soup", imageRight: "oden", categoryLeft: "サラダ", categoryCenter: "スープ", categoryRight: "おでん"),
    (header: "ガッツリ", imageLeft: "onigiri", imageCenter: "bread", imageRight: "bento", categoryLeft: "おむすび", categoryCenter: "パン", categoryRight: "麺・お弁当"),
    (header: "ジャンキー", imageLeft: "okashi", imageCenter: "hotsnack", imageRight: "drink", categoryLeft: "菓子", categoryCenter: "ホットスナック", categoryRight: "ドリンク")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return category.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
    cell.headerLabel.text = category[indexPath.row].header
    cell.imageLeft.image = UIImage(named: category[indexPath.row].imageLeft)
    cell.imageCenter.image = UIImage(named: category[indexPath.row].imageCenter)
    cell.imageRight.image = UIImage(named: category[indexPath.row].imageRight)
    cell.buttonLeft.setTitle(category[indexPath.row].categoryLeft, for: .normal)
    cell.buttonCenter.setTitle(category[indexPath.row].categoryCenter, for: .normal)
    cell.buttonRight.setTitle(category[indexPath.row].categoryRight, for: .normal)
    cell.buttonLeftAction = {
      let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let productView = storyboard.instantiateViewController(withIdentifier: "productView") as! ProductViewController
      productView.sendText = self.category[indexPath.row].categoryLeft
      self.navigationController?.pushViewController(productView, animated: true)
    }
    cell.buttonCenterAction = {
      let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let productView = storyboard.instantiateViewController(withIdentifier: "productView") as! ProductViewController
      productView.sendText = self.category[indexPath.row].categoryCenter
      self.navigationController?.pushViewController(productView, animated: true)
    }
    cell.buttonRightAction = {
      let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let productView = storyboard.instantiateViewController(withIdentifier: "productView") as! ProductViewController
      productView.sendText = self.category[indexPath.row].categoryRight
      self.navigationController?.pushViewController(productView, animated: true)
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
  }
}
