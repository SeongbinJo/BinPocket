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
    @IBOutlet weak var windowColorBtn: UIButton!
    @IBOutlet weak var themeSegmentBtn: UISegmentedControl!
    
    //Realm
    let realm = try! Realm()
    
    //Realm 데이터베이스가 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
    let picker = UIColorPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        //realm의 지정한 칼라 불러오기(ThemeColor 모델 이용)
        print(realm.objects(ThemeColor.self).count)
        print(realm.objects(ThemeColor.self))
        //realm의 ThemeColor 색 데이터에 맞는 색으로 ColorPicker 버튼 색 초기화.
        changeBookmarkColor()
        
        //realm - currentTheme()의 데이터에 변경이 감지되면 작동 -> 지정 색상을 변경하면 해당 테마에 맞게 색 변경하는 부분.
        var currentTheme = realm.objects(currentTheme.self)
        notificationToken = currentTheme.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("currentTheme 데이터 초기화됨.")
            case .update(_, let deletions, let insertions, let modifications):
                print("currentTheme 데이터 변경 감지됨//지정 색상 변경 감지")
                let backgroundColor: [CGFloat] = self!.getRgbData(index: "\(currentTheme.first!.themeStatus)").0
//                let textColor: [CGFloat] = self!.getRgbData(index: "\(currentTheme.first!.themeStatus)").1
//                let buttonColor: [CGFloat] = self!.getRgbData(index: "\(currentTheme.first!.themeStatus)").2
//                let tableColor: [CGFloat] = self!.getRgbData(index: "\(currentTheme.first!.themeStatus)").3
                self!.view.backgroundColor = UIColor(red: backgroundColor[0], green: backgroundColor[1], blue: backgroundColor[2], alpha: backgroundColor[3])
            case .error(let error):
                print("\(error)")
            }
        }
        
        //realm - ThemeColor()의 데이터에 변경이 감지되면 작동 -> ColorPicker에서 색을 선택하면 해당 색에 맞는 부분의 색을 변경하는 부분.
    }
    
    
    //색 데이터 rgb 뽑아내는 부분
    func getRgbData(index: String) -> ([CGFloat], [CGFloat], [CGFloat], [CGFloat]) {
        let data = realm.objects(ThemeColor.self).filter("index == %@", index)
        let backgroundData = data.first?.backgroundColor.split(separator: " ")
        let textData = data.first?.textColor.split(separator: " ")
        let buttonData = data.first?.buttonColor.split(separator: " ")
        let windowData = data.first?.windowColor.split(separator: " ")
        var backgroundColor: [CGFloat] = []
        var textColor: [CGFloat] = []
        var buttonColor: [CGFloat] = []
        var windowColor: [CGFloat] = []
        for i in 1...4 {
            backgroundColor.append(CGFloat(Double(backgroundData![i])!))
            textColor.append(CGFloat(Double(textData![i])!))
            buttonColor.append(CGFloat(Double(buttonData![i])!))
            windowColor.append(CGFloat(Double(windowData![i])!))
        }
        
        return (backgroundColor, textColor, buttonColor, windowColor)
    }
    
    //지정색상 세그먼트 컨트롤러
    var segmentStatus: Int = 0 {
        didSet {
            changeBookmarkColor()
        }
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
    
    //지정 색상 1, 2, 3 별 버튼 색
    func changeBookmarkColor() {
        switch segmentStatus {
        case 0:
            let backgroundColor: [CGFloat] = getRgbData(index: "0").0
            let textColor: [CGFloat] = getRgbData(index: "0").1
            let buttonColor: [CGFloat] = getRgbData(index: "0").2
            let tableColor: [CGFloat] = getRgbData(index: "0").3
            self.backgroundColorBtn.tintColor = UIColor(red: backgroundColor[0], green: backgroundColor[1], blue: backgroundColor[2], alpha: backgroundColor[3])
            self.textColorBtn.tintColor = UIColor(red: textColor[0], green: textColor[1], blue: textColor[2], alpha: textColor[3])
            self.buttonColorBtn.tintColor = UIColor(red: buttonColor[0], green: buttonColor[1], blue: buttonColor[2], alpha: buttonColor[3])
            self.windowColorBtn.tintColor = UIColor(red: tableColor[0], green: tableColor[1], blue: tableColor[2], alpha: tableColor[3])
        case 1:
            let backgroundColor: [CGFloat] = getRgbData(index: "1").0
            let textColor: [CGFloat] = getRgbData(index: "1").1
            let buttonColor: [CGFloat] = getRgbData(index: "1").2
            let tableColor: [CGFloat] = getRgbData(index: "1").3
            self.backgroundColorBtn.tintColor = UIColor(red: backgroundColor[0], green: backgroundColor[1], blue: backgroundColor[2], alpha: backgroundColor[3])
            self.textColorBtn.tintColor = UIColor(red: textColor[0], green: textColor[1], blue: textColor[2], alpha: textColor[3])
            self.buttonColorBtn.tintColor = UIColor(red: buttonColor[0], green: buttonColor[1], blue: buttonColor[2], alpha: buttonColor[3])
            self.windowColorBtn.tintColor = UIColor(red: tableColor[0], green: tableColor[1], blue: tableColor[2], alpha: tableColor[3])
        case 2:
            let backgroundColor: [CGFloat] = getRgbData(index: "2").0
            let textColor: [CGFloat] = getRgbData(index: "2").1
            let buttonColor: [CGFloat] = getRgbData(index: "2").2
            let tableColor: [CGFloat] = getRgbData(index: "2").3
            self.backgroundColorBtn.tintColor = UIColor(red: backgroundColor[0], green: backgroundColor[1], blue: backgroundColor[2], alpha: backgroundColor[3])
            self.textColorBtn.tintColor = UIColor(red: textColor[0], green: textColor[1], blue: textColor[2], alpha: textColor[3])
            self.buttonColorBtn.tintColor = UIColor(red: buttonColor[0], green: buttonColor[1], blue: buttonColor[2], alpha: buttonColor[3])
            self.windowColorBtn.tintColor = UIColor(red: tableColor[0], green: tableColor[1], blue: tableColor[2], alpha: tableColor[3])
        default:
            print("지정 색상 세그먼트 컨트롤러 선택 에러.")
        }
    }
    
    func buttonColor(index: Int) {
        let colorData = realm.objects(ThemeColor.self).filter("index == %@", index)
        print(colorData)
    }
    
    @IBAction func backgroundColorPicker(_ sender: UIButton) {
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
    
    //지정 색상 1, 2, 3 세그먼트 컨트롤러
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        let currentTheme = realm.objects(currentTheme.self).first
        if themeSegmentBtn.selectedSegmentIndex == 0 {
            self.segmentStatus = 0
            try! realm.write {
                currentTheme?.themeStatus = self.segmentStatus
            }
            print("지정 색상 1 클릭됨.")
        }else if themeSegmentBtn.selectedSegmentIndex == 1 {
            self.segmentStatus = 1
            try! realm.write {
                currentTheme?.themeStatus = self.segmentStatus
            }
            print("지정 색상 2 클릭됨.")
        }else {
            self.segmentStatus = 2
            try! realm.write {
                currentTheme?.themeStatus = self.segmentStatus
            }
            print("지정 색상 3 클릭됨.")
        }
    }
    
}

extension ThemeColorVC: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        switch segmentStatus {
        case 0:
            let editColor = realm.objects(ThemeColor.self).filter("index == %@", "0")
            switch self.typeStatus {
            case .background:
                //선택한 색상 색 데이터에 업데이트
                try! realm.write {
                    editColor.first?.backgroundColor = "\(viewController.selectedColor)"
                }
                //선택한 색상 Picker 버튼에 적용
                self.backgroundColorBtn.tintColor = viewController.selectedColor
            case .text:
                try! realm.write {
                    editColor.first?.textColor = "\(viewController.selectedColor)"
                }
                self.textColorBtn.tintColor = viewController.selectedColor
            case .button:
                try! realm.write {
                    editColor.first?.buttonColor = "\(viewController.selectedColor)"
                }
                self.buttonColorBtn.tintColor = viewController.selectedColor
            case .window:
                try! realm.write {
                    editColor.first?.windowColor = "\(viewController.selectedColor)"
                }
                self.windowColorBtn.tintColor = viewController.selectedColor
            case .none:
                break
            }
        case 1:
            let editColor = realm.objects(ThemeColor.self).filter("index == %@", "1")
            switch self.typeStatus {
            case .background:
                try! realm.write {
                    editColor.first?.backgroundColor = "\(viewController.selectedColor)"
                }
                self.backgroundColorBtn.tintColor = viewController.selectedColor
            case .text:
                try! realm.write {
                    editColor.first?.textColor = "\(viewController.selectedColor)"
                }
                self.textColorBtn.tintColor = viewController.selectedColor
            case .button:
                try! realm.write {
                    editColor.first?.buttonColor = "\(viewController.selectedColor)"
                }
                self.buttonColorBtn.tintColor = viewController.selectedColor
            case .window:
                try! realm.write {
                    editColor.first?.windowColor = "\(viewController.selectedColor)"
                }
                self.windowColorBtn.tintColor = viewController.selectedColor
            case .none:
                break
            }
        case 2:
            let editColor = realm.objects(ThemeColor.self).filter("index == %@", "1")
            switch self.typeStatus {
            case .background:
                try! realm.write {
                    editColor.first?.backgroundColor = "\(viewController.selectedColor)"
                }
                self.backgroundColorBtn.tintColor = viewController.selectedColor
            case .text:
                try! realm.write {
                    editColor.first?.textColor = "\(viewController.selectedColor)"
                }
                self.textColorBtn.tintColor = viewController.selectedColor
            case .button:
                try! realm.write {
                    editColor.first?.buttonColor = "\(viewController.selectedColor)"
                }
                self.buttonColorBtn.tintColor = viewController.selectedColor
            case .window:
                try! realm.write {
                    editColor.first?.windowColor = "\(viewController.selectedColor)"
                }
                self.windowColorBtn.tintColor = viewController.selectedColor
            case .none:
                break
            }
        default:
            print("색상 변경 문제 발생.")
        }
    }
    
}
