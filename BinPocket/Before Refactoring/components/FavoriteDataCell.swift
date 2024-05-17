//
//  AddSaveDataCell.swift
//  BinPocket
//
//  Created by 조성빈 on 2023/08/05.
//

import UIKit

class FavoriteDataCell: UITableViewCell{
    
    @IBOutlet weak var moneyTitle: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var plusOrMinus: UILabel!
    @IBOutlet weak var category: UILabel!
    var id: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
