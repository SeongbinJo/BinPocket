//
//  addlistVC.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds

class AddlistVC : UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var segementController: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var addBtn: Borderbutton!
    
    //애드몹 배너뷰
    var bannerView: GADBannerView!
    
    //Realm
    var realm = try! Realm()
    
    //지출, 수입 선택
    var plusminus : Bool = true
    
    //ViewlistVC에서 selectdate 받아오기
    var selectdate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        moneyTextField.delegate = self
        self.addBtn.isEnabled = true
        self.segementController.isSelected = false
        self.moneyTextField.keyboardType = .numberPad
        
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
//            print("지출을 선택함. \(segementController.isSelected)")
        }
        else{
            segementController.selectedSegmentTintColor = UIColor(r: 233, g: 81, b: 81, a: 0.3)
            //수입 칸 선택하면, false
            plusminus = false
            self.segementController.isSelected = true
//            print("수입을 선택함.")
        }
    }
    
    //추가 버튼
    @IBAction func addlistBtn(_ sender: Borderbutton) {
        //지출과 수입 선택에 따라 저장되는 값이 달라짐.
        //세그먼트 컨트롤러(지출 or 수입)이 선택 되어있으면~
        if self.segementController.isSelected && self.titleTextField.text != "" && self.moneyTextField.text != "" {
            if plusminus == false {
                //realm에 저장할 데이터 틀에 맞춰 데이터 생성.
                let pmoneylist = MyData()
                pmoneylist.date = selectdate
                pmoneylist.moneyTitle = titleTextField.text ?? ""
                pmoneylist.money = moneyTextField.text ?? ""
                pmoneylist.plusOrMinus = false
                pmoneylist.id = UUID().uuidString
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
                try! realm.write {
                    realm.add(mmoneylist)
                }
                self.dismiss(animated: true)
            }
        } else {
            //세그먼트 컨트롤러(지출 or 수입)이 선택 안되어있으면~
            let alert = UIAlertController(title:"잠깐!",
                message: "비어있는 항목이 있습니다.", preferredStyle: .alert)
            let okbtn = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okbtn)
            present(alert,animated: true, completion: nil)

        }
    }
}

extension AddlistVC : UITextFieldDelegate {
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
