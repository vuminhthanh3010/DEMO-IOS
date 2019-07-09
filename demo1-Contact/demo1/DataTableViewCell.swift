//
//  DataTableViewCell.swift
//  demo1
//
//  Created by Minh Thanh on 7/8/19.
//  Copyright © 2019 Minh Thanh. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var showPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
