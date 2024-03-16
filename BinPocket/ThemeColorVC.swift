//
//  ThemeColorVC.swift
//  BinPocket
//
//  Created by 조성빈 on 3/15/24.
//

import Foundation
import UIKit
import RealmSwift

class ThemeColorVC: UIViewController {
    
    @IBOutlet weak var backgroundColorBtn: UIButton!
    @IBOutlet weak var textColorBtn: UIButton!
    @IBOutlet weak var buttonColorBtn: UIButton!
    @IBOutlet weak var tableColorBtn: UIButton!
    @IBOutlet weak var themeSegmentBtn: UISegmentedControl!
    
    //Realm
    let realm = try! Realm()
    
    let picker = UIColorPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        //realm의 지정한 칼라 불러오기(ThemeColor 모델 이용)
        print(realm.objects(ThemeColor.self).count)
        print(realm.objects(ThemeColor.self))
        print(realm.objects(ThemeColor.self).first)
    }
    
    //색을 변경할 컴포넌트 구분
    enum ColorValue {
        case background
        case text
        case button
        case window
    }
    
    //현재 선택한 컴포넌트
    var typeStatus: ColorValue?
    
    //선택한 컴포넌트의 ColorPicker를 present
    func presentColorPicker(type: ColorValue) {
        typeStatus = type
        self.present(picker, animated: true, completion: nil)
    }
    
    //컴포넌트 별 ColorPicker에서 선택한 색을 String 타입변환 후 색 데이터에 Update
    func updateColor(type: ColorValue) {
        let themeColor = realm.objects(ThemeColor.self).first
    }
    
    @IBAction func backgroundColorPicker(_ sender: Any) {
        presentColorPicker(type: .background)
    }
    
    @IBAction func textColorPicker(_ sender: Any) {
        presentColorPicker(type: .text)
    }
    
    @IBAction func buttonColorPicker(_ sender: Any) {
        presentColorPicker(type: .button)
    }
    
    @IBAction func tableColorPicker(_ sender: Any) {
        presentColorPicker(type: .window)
    }
    
    
}

extension ThemeColorVC: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        switch self.typeStatus {
        case .background:
            print("최종 선택한 background 칼라 : ", viewController.selectedColor)
            print(type(of: viewController.selectedColor))
        case .text:
            print("최종 선택한 text 칼라 : ", viewController.selectedColor)
        case .button:
            print("최종 선택한 button 칼라 : ", viewController.selectedColor)
        case .window:
            print("최종 선택한 table 칼라 : ", viewController.selectedColor)
        case .none:
            break
        }
    }
    
}
