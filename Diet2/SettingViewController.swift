//
//  SettingViewController.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/15.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

  @IBOutlet weak var pickerView: UIPickerView!
  let settingKey = "carboLimit"
  
  let settingArray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      pickerView.delegate = self
      pickerView.dataSource = self
      
      let setting = UserDefaults.standard
      if setting.object(forKey: settingKey) != nil {
        let carboValue = setting.integer(forKey: settingKey)
        for row in 0..<settingArray.count {
          if settingArray[row] == carboValue {
            pickerView.selectRow(row, inComponent: 0, animated: true)
          }
        }
      } else {
        setting.register(defaults: [settingKey : 100])
      }
    }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return settingArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(settingArray[row])
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let setting = UserDefaults.standard
    setting.setValue(settingArray[row], forKey: settingKey)
    setting.synchronize()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
