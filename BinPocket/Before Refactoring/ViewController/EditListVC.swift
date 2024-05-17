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
    @IBOutlet weak var addFavoriteDataButton: Borderbutton!
    @IBOutlet weak var favoriteDataTableView: UITableView!
    
    @IBOutlet weak var selectCategoryBtn: Borderbutton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var favoriteTableBox: Borderview!
    //realm
    var realm = try! Realm()
    
    //Realm 데이터베이스 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
    //ViewlistVC에서 선택한 셀의 정보 담을 변수들.
    var selectCellDate = ""
    var selectCellPlusOrMinus = false  //0 -> 수입, 1 -> 지출
    var selectCellTitle = ""
    var selectCellMoney = ""
    var selectId = ""
    var selectCategory = ""
    
    //세그먼트 컨트롤러
    var plusMinus = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTitleTextField.delegate = self
        editMoneyTextField.delegate = self
        favoriteDataTableView.delegate = self
        favoriteDataTableView.dataSource = self
        editTitleTextField.text = selectCellTitle
        editMoneyTextField.text = selectCellMoney.trimmingCharacters(in: ["-"])
        categoryLabel.text = selectCategory
        self.editMoneyTextField.keyboardType = .numberPad
        
        //데이터베이스 변경될 때마다 테이블 뷰 리로드.
        notificationToken = realm.observe({ (noti, realm) in
            self.favoriteDataTableView.reloadData();
        })
        
        if selectCellPlusOrMinus{
            editSegementController.selectedSegmentIndex = 0
            editSegementController.selectedSegmentTintColor = UIColor(r: 63, g: 137, b: 249, a: 0.3)
            plusMinus = true
        }else{
            editSegementController.selectedSegmentIndex = 1
            editSegementController.selectedSegmentTintColor = UIColor(r: 233, g: 81, b: 81, a: 0.3)
            plusMinus = false
        }
        
        
        
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
        if self.editSegementController.isSelected && self.editTitleTextField.text != "" && self.editMoneyTextField.text != "" && self.categoryLabel.text != "비어있음" {
            let editData = realm.objects(MyData.self).filter("date == %@ AND id == %@", selectCellDate, selectId)
            //true = 지출
            if plusMinus{
                try! realm.write{
                    for data in editData{
                        data.moneyTitle = self.editTitleTextField.text!
                        data.money = "-" + self.editMoneyTextField.text!
                        data.plusOrMinus = self.plusMinus
                        data.category = self.categoryLabel.text!
                    }
                }
            }else{
                try! realm.write{
                    for data in editData{
                        data.moneyTitle = self.editTitleTextField.text!
                        data.money = self.editMoneyTextField.text!
                        data.plusOrMinus = self.plusMinus
                        data.category = self.categoryLabel.text!
                    }
                }
            }
            self.dismiss(animated: true)
        }else{
            //수정 페이지에서 아무것도 작성되어있지 않을때.
            let alert = UIAlertController(title:"잠깐!",
                message: "비어있는 항목이 있습니다! 삭제를 원하시면 해당 내역을 왼쪽으로 밀어주세요!", preferredStyle: .alert)
            let okbtn = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okbtn)
            present(alert,animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addFavoriteBtn(_ sender: Any) {
        if self.editSegementController.isSelected && self.editTitleTextField.text != "" && self.editMoneyTextField.text != "" && self.categoryLabel.text != "비어있음" {
            if plusMinus == false{
                let favoriteList = FavoriteData()
                favoriteList.moneyTitle = editTitleTextField.text ?? ""
                favoriteList.money = editMoneyTextField.text ?? ""
                favoriteList.plusOrMinus = false
                favoriteList.id = UUID().uuidString
                favoriteList.category = categoryLabel.text ?? ""
                try! realm.write{
                    realm.add(favoriteList)
                }
            }
            if plusMinus == true{
                let favoriteList = FavoriteData()
                favoriteList.moneyTitle = editTitleTextField.text ?? ""
                favoriteList.money = "-\(editMoneyTextField.text ?? "")"
                favoriteList.plusOrMinus = true
                favoriteList.id = UUID().uuidString
                favoriteList.category = categoryLabel.text ?? ""
                try! realm.write{
                    realm.add(favoriteList)
                }
            }
        }else {
            //세그먼트 컨트롤러(지출 or 수입)이 선택 안되어있으면~
            let alert = UIAlertController(title:"잠깐!",
                message: "비어있는 항목이 있습니다.", preferredStyle: .alert)
            let okbtn = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okbtn)
            present(alert,animated: true, completion: nil)
        }
    }
    
    @IBAction func goToCategoryVCBtn(_ sender: Any) {
        guard let categoryPage = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as? SelectCategoryVC else { return }
        categoryPage.selectedCategory = { category in
            self.categoryLabel.text = category
        }
        self.present(categoryPage, animated: true)
    }
    
}

extension EditListVC : UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realm.objects(FavoriteData.self).count > 0{
            return realm.objects(FavoriteData.self).count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteDataCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteDataCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        
        if realm.objects(FavoriteData.self).count > 0{
            let favoriteData = realm.objects(FavoriteData.self)
            cell.moneyTitle.text = "\(favoriteData[indexPath.row].moneyTitle)"
            cell.money.text = "\(MainVC.decimalWon(value: Int(favoriteData[indexPath.row].money)!))"
            cell.plusOrMinus.text = favoriteData[indexPath.row].plusOrMinus ? "(지출)" : "(수입)"
            cell.id = favoriteData[indexPath.row].id
            cell.category.text = "[\(favoriteData[indexPath.row].category)]"
            print(type(of: favoriteData[indexPath.row].category))
        }
        return cell
    }
    
    //셀 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currentcell: FavoriteDataCell = tableView.cellForRow(at: indexPath) as! FavoriteDataCell
        if editingStyle == .delete{
            let favoriteData = realm.objects(FavoriteData.self).filter("id == %@", currentcell.id)
            tableView.beginUpdates()
            try! realm.write{
                realm.delete(favoriteData)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제하기"
    }
    
    //즐겨찾기 테이블 셀 클릭했을때.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentcell: FavoriteDataCell = tableView.cellForRow(at: indexPath) as! FavoriteDataCell
        let selectedCell = realm.objects(FavoriteData.self).filter("id == %@", currentcell.id)
        self.editTitleTextField.text = selectedCell.first!.moneyTitle
        self.editMoneyTextField.text = selectedCell.first!.money.trimmingCharacters(in: ["-"])
        self.categoryLabel.text = selectedCell.first!.category
        self.editSegementController.selectedSegmentIndex = selectedCell.first!.plusOrMinus ? 0 : 1
        self.plusMinus = selectedCell.first!.plusOrMinus ? true : false
        self.editSegementController.isSelected = true
        self.editSegementController.selectedSegmentTintColor = selectedCell.first!.plusOrMinus ? UIColor(r: 63, g: 137, b: 249, a: 0.3) : UIColor(r: 233, g: 81, b: 81, a: 0.3)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
