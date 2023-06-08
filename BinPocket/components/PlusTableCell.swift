//
//  PlusTableCell.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/28.
//

import UIKit

class PlusTableCell: UITableViewCell {

    //수입 셀 라벨
    @IBOutlet weak var plusCellTitle: UILabel!
    @IBOutlet weak var plusCellMoney: UILabel!
    
    //지출 셀 라벨
    @IBOutlet weak var minusCellTitle: UILabel!
    @IBOutlet weak var minusCellMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
