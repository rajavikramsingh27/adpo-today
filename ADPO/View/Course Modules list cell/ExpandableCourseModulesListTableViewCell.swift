//
//  TableViewCell.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 17.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ExpandableCourseModulesListTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImageView: UIImageView! //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
