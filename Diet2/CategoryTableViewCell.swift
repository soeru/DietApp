//
//  CategoryTableViewCell.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/09.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var imageLeft: UIImageView!
  @IBOutlet weak var imageCenter: UIImageView!
  @IBOutlet weak var imageRight: UIImageView!
  @IBOutlet weak var buttonLeft: UIButton!
  @IBOutlet weak var buttonCenter: UIButton!
  @IBOutlet weak var buttonRight: UIButton!
  
  var buttonLeftAction: (()->Void)?
  var buttonCenterAction: (()->Void)?
  var buttonRightAction: (()->Void)?
  
  @IBAction func buttonLeftTapped(_ sender: Any) {
    buttonLeftAction?()
  }
  
  @IBAction func buttonCenterTapped(_ sender: Any) {
    buttonCenterAction?()
  }
  
  @IBAction func buttonRightTapped(_ sender: Any) {
    buttonRightAction?()
  }
  
}
