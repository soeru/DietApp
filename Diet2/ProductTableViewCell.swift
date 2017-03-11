//
//  ProductTableViewCell.swift
//  Diet2
//
//  Created by 添田祐輝 on 2017/03/09.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var storeLabel: UILabel!
  @IBOutlet weak var carboLabel: UILabel!
}
