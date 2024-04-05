//
//  bordercollectionview.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import Foundation
import UIKit

@IBDesignable

class Borderview : UIView {
    
    @IBInspectable
    var borderwidth : CGFloat = 1 {
        didSet{
            self.layer.borderWidth = borderwidth
        }
    }
    
    @IBInspectable
    var bordercolor : UIColor = UIColor(red: 232, green: 236, blue: 244, alpha: 1) {
        didSet {
            self.layer.borderColor = bordercolor.cgColor
        }
    }
    
    @IBInspectable
    var cornerradius : CGFloat = 12 {
        didSet {
            self.layer.cornerRadius = cornerradius
        }
    }
    
    @IBInspectable
    var hasshadow : Bool = false {
        didSet {
            guard hasshadow == true else { return }
            self.layer.applyShadow()
        }
    }
    
}
