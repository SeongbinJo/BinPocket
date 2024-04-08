//
//  CategoryRankTableViewCell.swift
//  BinPocket
//
//  Created by 조성빈 on 4/8/24.
//

import Foundation
import UIKit

class CategoryRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var minusRank: UIStackView!
    @IBOutlet weak var minusCategory: UIStackView!
    @IBOutlet weak var minusPercentage: UIStackView!
    
    @IBOutlet weak var plusRank: UILabel!
    @IBOutlet weak var plusCategory: UILabel!
    @IBOutlet weak var plusPercentage: UILabel!
    
}
