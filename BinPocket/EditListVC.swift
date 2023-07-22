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
    
    //애드몹 배너뷰
    var bannerView: GADBannerView!
    
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
        if selectCellPlusOrMinus{
            editSegementController.selectedSegmentIndex = 0
            editSegementController.selectedSegmentTintColor = UIColor(r: 63, g: 137, b: 249, a: 0.3)
        }else{
            editSegementController.selectedSegmentIndex = 1
            editSegementController.selectedSegmentTintColor = UIColor(r: 233, g: 81, b: 81, a: 0.3)
        }
        
        //애드몹 배너 사이즈 정하기.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        //애드몹 배너 넣기.
        addBannerViewToView(bannerView)
        
        //info.plist와 같아야함!
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
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
