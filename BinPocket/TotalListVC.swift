//
//  totalListVC.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import Foundation
import UIKit
import RealmSwift

class TotalListVC : UIViewController {
    
    @IBOutlet weak var totalTableView: UITableView!
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalTableView.delegate = self
        totalTableView.dataSource = self
        
    }
    
}


extension TotalListVC : UITableViewDelegate, UITableViewDataSource {
    //셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("내역이 존재하는 월 갯수 : \(totalMoneyCellCount())")
        return totalMoneyCellCount()
    }
    
    //셀 작성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TotalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TotalTableViewCell", for: indexPath) as! TotalTableViewCell
        //셀 커스텀
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        
        cell.totalTitle.text = "\(totalTitleCell(indexpath: indexPath.row))"
        if totalMoneyCell(indexpath: indexPath.row) > 0 {
            cell.totalMoney.text = "+\(MainVC.decimalWon(value: totalMoneyCell(indexpath: indexPath.row)))"
            cell.totalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
        }else if totalMoneyCell(indexpath: indexPath.row) < 0 {
            cell.totalMoney.text = "\(MainVC.decimalWon(value: totalMoneyCell(indexpath: indexPath.row)))"
            cell.totalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
        }else {
            cell.totalMoney.text = "\(MainVC.decimalWon(value: totalMoneyCell(indexpath: indexPath.row)))"
        }
        
        return cell
    }
    
    //셀을 클릭했을 때.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀을 클릭하면 이펙트 나왔다 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
        //현재 클릭한 셀 정보를 가져오기위한 변수 선언.
        let currentcell : TotalTableViewCell = tableView.cellForRow(at: indexPath) as! TotalTableViewCell
        print(currentcell.totalTitle.text!)
        //클릭한 셀의 totaltitle.text 값을 빼옴.
        let currentDate = currentcell.totalTitle.text!
        //월별 지출액 현황 모달뷰 dismiss
        self.dismiss(animated: true)
        //notification 명령 발신 -> object에 값을 전달할 수도 있다.
        NotificationCenter.default.post(name: .goToMyMonth, object: currentDate)
    }
    
    //월을 1씩 증가하면서 realm데이터에서 해당 월을 포함하는 데이터를 찾고, 1개 이상 존재하면 카운트 += 1 하는 함수.
    //numberOfRowsInSection에 넣을 int값 구하는 함수.
    func totalMoneyCellCount() -> Int {
        var year = 2020
        var month = 1
        var count = 0
        while(year <= 2050) {
            let abc = realm.objects(MyData.self).filter("date contains %@", "\(year)년 \(month)월")
            if abc.count > 0 {
                count += 1
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }else {
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }
        }
        return count
    }
    //월을 1씩 증가하면서 realm데이터에서 해당 월을 포함하는 데이터를 찾고, 1개 이상 존재하면 해당 년,월을 String값으로 totaldate에 append하고 cell부분에서 indexPath.row로 출력함.
    //cellForRowAt에 넣을 함수. cell.totaltitle.text
    func totalTitleCell(indexpath: Int) -> String {
        var year = 2020
        var month = 1
        var totaldate : [String] = []
        while(year <= 2050) {
            let filterdate = realm.objects(MyData.self).filter("date contains %@", "\(year)년 \(month)월")
            if filterdate.count > 0 {
                totaldate.append("\(year)년 \(month)월")
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }else {
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }
        }
        return totaldate[indexpath]
    }
    //월을 1씩 증가하면서 realm데이터에서 해당 월을 포함하는 데이터를 찾고, 1개이상 존재하면 money들을 합하여 totalmoney에 append하고 cell부분에서 indexPath.row로 출력함.
    //cellForRowAt에 넣을 함수. cell.totalmoney.text
    func totalMoneyCell(indexpath: Int) -> (Int) {
        var year = 2020
        var month = 1
        var summoney = 0
        var totalmoney : [Int] = []

        while(year <= 2050) {
            let filterdate = realm.objects(MyData.self).filter("date contains %@", "\(year)년 \(month)월")
            if filterdate.endIndex - 1 >= 0 {
                for i in 0...filterdate.endIndex - 1 {
                    summoney += Int(filterdate[i].money)!
                }
                //해당 월 합계금액 배열에 추가
                totalmoney.append(summoney)
                //다른 해당 월의 합계금액을 구하기위해 0으로 초기화.
                summoney = 0
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }else {
                summoney = 0
                month += 1
                if month > 12 {
                    month = 1
                    year += 1
                }
            }
        }
        return totalmoney[indexpath]
    }

    
}

