//
//  EditListVC.swift
//  BinPocket
//
//  Created by 조성빈 on 2023/06/30.
//

import Foundation
import UIKit
import RealmSwift

class EditListVC : UIViewController {
    
    @IBOutlet weak var editSegementController: UISegmentedControl!
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editMoneyTextField: UITextField!
    @IBOutlet weak var editBtn: Borderbutton!
    
    //realm
    var realm = try! Realm()
    
    //ViewlistVC에서 선택한 셀의 정보 담을 변수들.
    var selectCellDate = ""
    //0 -> 수입, 1 -> 지출
    var selectCellPlusOrMinus = false
    var selectCellTitle = ""
    var selectCellMoney = ""
    
    //완전히 값이 같은 내역을 구분하기위한 id변수.
    var selectId = ""
    
    //세그먼트 컨트롤러
    var plusMinus = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTitleTextField.delegate = self
        editMoneyTextField.delegate = self
        editTitleTextField.text = selectCellTitle
        editMoneyTextField.text = selectCellMoney.trimmingCharacters(in: ["-"])
        self.editMoneyTextField.keyboardType = .numberPad
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if editSegementController.selectedSegmentIndex == 0{
            editSegementController.selectedSegmentTintColor = UIColor(r: 63, g: 137, b: 249, a: 0.3)
            self.plusMinus = true
            self.editSegementController.isSelected = true
        }else{
            editSegementController.selectedSegmentTintColor = UIColor(r: 233, g: 81, b: 81, a: 0.3)
            self.plusMinus = false
            self.editSegementController.isSelected = true
        }
    }
    
    @IBAction func editBtn(_ sender: Borderbutton) {
        let editData = realm.objects(MyData.self).filter("date == %@ AND moneyTitle == %@ AND money == %@ AND plusOrMinus == %@ AND id == %@", selectCellDate, selectCellTitle, selectCellMoney, selectCellPlusOrMinus, selectId)
        //true = 지출
        if plusMinus{
            try! realm.write{
                for data in editData{
                    data.moneyTitle = self.editTitleTextField.text!
                    data.money = "-" + self.editMoneyTextField.text!
                    data.plusOrMinus = self.plusMinus
                }
            }
        }else{
            try! realm.write{
                for data in editData{
                    data.moneyTitle = self.editTitleTextField.text!
                    data.money = self.editMoneyTextField.text!
                    data.plusOrMinus = self.plusMinus
                }
            }
        }
        print("변경된 값은 제목 : \(editTitleTextField.text!), 금액 : \(editMoneyTextField.text!), 지출/수입 : \(plusMinus)")
        self.dismiss(animated: true)
    }
    
}

extension EditListVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //moneytextfield에 숫자만 입력가능하게.
        if textField == self.editMoneyTextField {
            let allowcharset = CharacterSet(charactersIn: "0123456789")
            let moneytftext = CharacterSet(charactersIn: string)
            let onlynumber = allowcharset.isSuperset(of: moneytftext)
            
            return onlynumber
        }
        return true
    }
}
