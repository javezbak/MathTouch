//
//  TableViewLatexCell.swift
//  MathTouch_Unified
//
//  Created by Rayan Tejuja on 4/28/18.
//  Copyright © 2018 B22. All rights reserved.
//

import UIKit

class TableViewLatexCell: UITableViewCell {

    @IBOutlet weak var LatexCellViewLabel: UILabel!
    
    @IBOutlet weak var LatexCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
