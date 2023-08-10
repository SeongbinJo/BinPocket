//
//  EditListVC.swift
//  BinPocket
//
//  Created by 조성빈 on 2023/06/30.
//

import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds

class EditListVC : UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var editSegementController: UISegmentedControl!
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editMoneyTextField: UITextField!
    @IBOutlet weak var editBtn: Borderbutton!
    @IBOutlet weak var addFavoriteDataButton: Borderbutton!
    @IBOutlet weak var favoriteDataTableView: UITableView!
    
    //애드몹 배너뷰
    var bannerView: GADBannerView!
    
    //realm
    var realm = try! Realm()
    
    //Realm 데이터베이스 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
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
        favoriteDataTableView.delegate = self
        favoriteDataTableView.dataSource = self
        editTitleTextField.text = selectCellTitle
        editMoneyTextField.text = selectCellMoney.trimmingCharacters(in: ["-"])
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
        
        //애드몹 배너 사이즈 정하기.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        //애드몹 배너 넣기.
        addBannerViewToView(bannerView)
        
        //info.plist와 같아야함!
        bannerView.adUnitID = "ca-app-pub-3940256099942544~1458002511"
        bannerView.rootViewController = self
        //광고 로드
        bannerView.load(GADRequest())
        //배너뷰 델리게이트
        bannerView.delegate = self
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        //애드몹 광고 배너 오토레이아웃.
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
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
        if self.editSegementController.isSelected && self.editTitleTextField.text != "" && self.editMoneyTextField.text != "" {
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
        if self.editSegementController.isSelected && self.editTitleTextField.text != "" && self.editMoneyTextField.text != ""{
            if plusMinus == false{
                let favoriteList = FavoriteData()
                favoriteList.moneyTitle = editTitleTextField.text ?? ""
                favoriteList.money = editMoneyTextField.text ?? ""
                favoriteList.plusOrMinus = false
                favoriteList.id = UUID().uuidString
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
    
    //MARK - GADBannerViewDelegate 관련 메소드
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
//        //애드몹 배너 넣기.
//        addBannerViewToView(bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
}
