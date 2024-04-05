//
//  PlusTableCell.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/28.
//

import UIKit

class TableCell: UITableViewCell {

    //수입 셀 라벨
    @IBOutlet weak var plusCellTitle: UILabel!
    @IBOutlet weak var plusCellMoney: UILabel!
    @IBOutlet weak var plusCategory: UILabel!
    var plusId: String = ""
    
    //지출 셀 라벨
    @IBOutlet weak var minusCellTitle: UILabel!
    @IBOutlet weak var minusCellMoney: UILabel!
    @IBOutlet weak var minusCategory: UILabel!
    var minusId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
