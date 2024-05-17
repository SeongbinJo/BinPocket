//
//  TotalTableViewCell.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/02/07.
//

import UIKit

class TotalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
