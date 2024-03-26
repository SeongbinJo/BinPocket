//
//  addlistVC.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import Foundation
import UIKit
import RealmSwift

class AddlistVC : UIViewController {
    
    @IBOutlet weak var segementController: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var addBtn: Borderbutton!
    @IBOutlet weak var addFavoriteDataButton: Borderbutton!
    @IBOutlet weak var favoriteDataTableView: UITableView!
    @IBOutlet weak var selectCategoryBtn: Borderbutton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var favoriteTableBox: Borderview!
    
    //Realm
    var realm = try! Realm()
    
    //Realm 데이터베이스 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
    //지출, 수입 선택
    var plusminus : Bool = true
    
    //ViewlistVC에서 selectdate 받아오기
    var selectdate = ""
    
    var dataArray : Results<FavoriteData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        moneyTextField.delegate = self
        favoriteDataTableView.delegate = self
        favoriteDataTableView.dataSource = self
//        favoriteDataTableView.isEditing = true
        self.addBtn.isEnabled = true
        self.segementController.isSelected = false
        self.moneyTextField.keyboardType = .numberPad
        
    
        
        
        //데이터베이스 변경될 때마다 테이블 뷰 리로드.
        notificationToken = realm.observe({ (noti, realm) in
            self.favoriteDataTableView.reloadData();
        })
        
        dataArray = realm.objects(FavoriteData.self)
        
    }

    
    //titletextfield 길이제한.
    @IBAction func titleTextFieldMaxLength(sender: Any) {
        textfieldMaxLength(textfield: titleTextField, maxlength: 20)
    }
    //moneytextfield 길이제한.
    @IBAction func moneyTextFieldMaxLength(sender: Any) {
        textfieldMaxLength(textfield: moneyTextField, maxlength: 8)
    }
    
    //텍스트필드 길이제한 함수.
    func textfieldMaxLength(textfield: UITextField, maxlength: Int) {
        if textfield.text!.count > maxlength {
            textfield.deleteBackward()
        }
    }
    
    //세그먼트 컨트롤러 액션
    @IBAction func segementAction(_ sender: UISegmentedControl) {
        if segementController.selectedSegmentIndex == 0 {
            segementController.selectedSegmentTintColor = UIColor(r: 63, g: 137, b: 249, a: 0.3)
            //지출 칸 선택하면, true
            plusminus = true
            self.segementController.isSelected = true
            print("지출을 선택함.")
        }
        else{
            segementController.selectedSegmentTintColor = UIColor(r: 233, g: 81, b: 81, a: 0.3)
            //수입 칸 선택하면, false
            plusminus = false
            self.segementController.isSelected = true
            print("수입을 선택함.")
        }
    }
    
    //추가 버튼
    @IBAction func addlistBtn(_ sender: Borderbutton) {
        //지출과 수입 선택에 따라 저장되는 값이 달라짐.
        //세그먼트 컨트롤러(지출 or 수입)이 선택 되어있으면~
        if self.segementController.isSelected && self.titleTextField.text != "" && self.moneyTextField.text != "" && self.categoryLabel.text != "비어있음" {
            if plusminus == false {
                //realm에 저장할 데이터 틀에 맞춰 데이터 생성.
                let pmoneylist = MyData()
                pmoneylist.date = selectdate
                pmoneylist.moneyTitle = titleTextField.text ?? ""
                pmoneylist.money = moneyTextField.text ?? ""
                pmoneylist.plusOrMinus = false
                pmoneylist.id = UUID().uuidString
                pmoneylist.category = categoryLabel.text ?? ""
                //데이터를 realm에 넣음.
                try! realm.write {
                    realm.add(pmoneylist)
                }
//                print("mydata의 데이터 목록 : \(realm.objects(MyData.self))")
                self.dismiss(animated: true)
            }
            if plusminus == true {
                let mmoneylist = MyData()
                mmoneylist.date = selectdate
                mmoneylist.moneyTitle = titleTextField.text ?? ""
                mmoneylist.money = "-\(moneyTextField.text ?? "")"
                mmoneylist.plusOrMinus = true
                mmoneylist.id = UUID().uuidString
                mmoneylist.category = categoryLabel.text ?? ""
                try! realm.write {
                    realm.add(mmoneylist)
                }
                self.dismiss(animated: true)
            }
        }else{
            //세그먼트 컨트롤러(지출 or 수입)이 선택 안되어있으면~
            let alert = UIAlertController(title:"잠깐!",
                message: "비어있는 항목이 있습니다.", preferredStyle: .alert)
            let okbtn = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okbtn)
            present(alert,animated: true, completion: nil)
        }
    }
    
    //즐겨찾기 추가버튼
    @IBAction func addFavoriteBtn(_ sender: Any) {
        if self.segementController.isSelected && self.titleTextField.text != "" && self.moneyTextField.text != "" && self.categoryLabel.text != "비어있음" {
            if plusminus == false{
                let favoriteList = FavoriteData()
                favoriteList.moneyTitle = titleTextField.text ?? ""
                favoriteList.money = moneyTextField.text ?? ""
                favoriteList.plusOrMinus = false
                favoriteList.id = UUID().uuidString
                favoriteList.category = categoryLabel.text ?? ""
                try! realm.write{
                    realm.add(favoriteList)
                }
            }
            if plusminus == true{
                let favoriteList = FavoriteData()
                favoriteList.moneyTitle = titleTextField.text ?? ""
                favoriteList.money = "-\(moneyTextField.text ?? "")"
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
    
    //카테고리 선택 페이지 이동
    @IBAction func goToCategoryVCBtn(_ sender: Any) {
        guard let categoryPage = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as? SelectCategoryVC else { return }
        categoryPage.selectedCategory = { category in
            self.categoryLabel.text = category
        }
        self.present(categoryPage, animated: true)
    }
    
}

//셀 개수
extension AddlistVC : UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realm.objects(FavoriteData.self).count > 0{
            return realm.objects(FavoriteData.self).count
        }else{
            return 0
        }
    }
    
    //셀 표현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteDataCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteDataCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        
        if realm.objects(FavoriteData.self).count > 0{
            let favoriteData = realm.objects(FavoriteData.self)
            cell.moneyTitle.text = "\(favoriteData[indexPath.row].moneyTitle)"
            cell.money.text = "\(MainVC.decimalWon(value: Int(favoriteData[indexPath.row].money)!))"
            cell.plusOrMinus.text = favoriteData[indexPath.row].plusOrMinus ? "(지출)" : "(수입)"
            cell.id = favoriteData[indexPath.row].id
            cell.category.text = "[\(favoriteData[indexPath.row].category)]"
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
        self.titleTextField.text = selectedCell.first!.moneyTitle
        self.moneyTextField.text = selectedCell.first!.money.trimmingCharacters(in: ["-"])
        self.segementController.selectedSegmentIndex = selectedCell.first!.plusOrMinus ? 0 : 1
        self.plusminus = selectedCell.first!.plusOrMinus ? true : false
        self.segementController.isSelected = true
        self.segementController.selectedSegmentTintColor = selectedCell.first!.plusOrMinus ? UIColor(r: 63, g: 137, b: 249, a: 0.3) : UIColor(r: 233, g: 81, b: 81, a: 0.3)
        self.categoryLabel.text = selectedCell.first!.category
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //텍스트필드 조건 거는 부분
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //moneytextfield에 숫자만 입력가능하게.
        if textField == self.moneyTextField {
            let allowcharset = CharacterSet(charactersIn: "0123456789")
            let moneytftext = CharacterSet(charactersIn: string)
            let onlynumber = allowcharset.isSuperset(of: moneytftext)
            
            return onlynumber
        }
        return true
    }
   
}
