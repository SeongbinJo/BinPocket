//
//  datemoneylistVC.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import Foundation
import UIKit
import RealmSwift

class ViewlistVC : UIViewController {
    
    
    @IBOutlet weak var plusTableView: UITableView!
    @IBOutlet weak var minusTableView: UITableView!
    @IBOutlet weak var dayTotalMoney: UILabel!
    @IBOutlet weak var prevDateBtn: UIButton!
    @IBOutlet weak var nextDateBtn: UIButton!
    @IBOutlet weak var totalPlusMoney: UILabel!
    @IBOutlet weak var totalMinusMoney: UILabel!
    
    //realm
    var realm = try! Realm()
    var plusMoneyList : Results<MyData>?
    var minusMoneyList : Results<MyData>?
    
    //Realm 데이터베이스가 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
    //MainVC에서 selectdate 받아오기.
    var selectdate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem()
        plusTableView.delegate = self
        plusTableView.dataSource = self
        minusTableView.delegate = self
        minusTableView.dataSource = self
        plusMoneyList = realm.objects(MyData.self).filter("plusOrMinus == 0")
        minusMoneyList = realm.objects(MyData.self).filter("plusOrMinus == 1")
        print("realm1 mydata : \(realm.objects(MyData.self))")
        //데이터베이스가 변경될때마다 테이블 뷰 리로드하는 코드.
        notificationToken = realm.observe({ (noti, realm) in
            self.plusTableView.reloadData(); self.minusTableView.reloadData();
        })
        
    }
    //이전 날
    @IBAction func prevDate(_ sender: Any) {
        prevNextDate(time: -86400)
    }
    
    @IBAction func nextDate(_ sender: Any) {
        prevNextDate(time: 86400)
    }
    
    //선택한 날짜에 하루를 더하고 빼기위한 함수. 1일은 86400이다.
    //self.navigationItem.title을 변화시키기 때문에 바뀌어야하는 몇몇의 selectdate를 self.navigationItem.title로 변경함.
    func prevNextDate(time: TimeInterval) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년 M월 d일"
        let date1 = dateformatter.date(from: self.navigationItem.title!)!.addingTimeInterval(time)
        let resultdate = dateformatter.string(from: date1)
        self.title = resultdate
        self.plusTableView.reloadData()
        self.minusTableView.reloadData()
    }
    
    //네비게이션 바
    func naviItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(goAddListPage(sender:))) // action:에 함수를 넣기 위해선 @objc func만이 가능하다.
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = selectdate
    }
    
    //네이게이션 바 + 버튼 작동
    @objc func goAddListPage(sender: UIBarButtonItem) {
        guard let addviewpage = self.storyboard?.instantiateViewController(withIdentifier: "AddlistVC") as? AddlistVC else { return }
        addviewpage.selectdate = self.navigationItem.title!
        self.present(addviewpage, animated: true)
    }
    
    //선택한 날짜별 수입/지출금의 총 합계.
    func dateTotalFunc() -> Int {
        var datetotalfunc = 0
        //선택한 날짜인 money의 합계.
        let filterselectdate = realm.objects(MyData.self).filter("date == %@", self.navigationItem.title as Any)
        if filterselectdate.endIndex - 1 >= 0 {
            for i in 0...filterselectdate.endIndex - 1 {
                datetotalfunc = datetotalfunc + (Int(filterselectdate[i].money)!)
            }
        }else {
            datetotalfunc = 0
        }
        return datetotalfunc
    }
    //선택한 날짜별 수입과 지출의 각각 합계.
    func dateTotalPlusMinusMoney(bool: Bool) -> Int {
        var dateTotalPlusMoney = 0
        let filterselectdate = realm.objects(MyData.self).filter("date == %@ AND plusOrMinus == \(bool)", self.navigationItem.title as Any)
        if filterselectdate.endIndex - 1 >= 0 {
            for i in 0...filterselectdate.endIndex - 1 {
                dateTotalPlusMoney = dateTotalPlusMoney + (Int(filterselectdate[i].money)!)
            }
        }else {
            dateTotalPlusMoney = 0
        }
        return dateTotalPlusMoney
    }
    
}


//테이블 뷰 델리게이트, 데이터소스 확장.
extension ViewlistVC : UITableViewDelegate, UITableViewDataSource {
    
    //셀 개수 지정.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰가 지출, 수입 총 2개이므로 if 문으로 나눔
        if tableView == plusTableView {
            //메인화면에서 클릭한 날짜의 데이터만 출력하기 위해서 조건문 사용
            if realm.objects(MyData.self).filter("date == %@", self.navigationItem.title as Any).count > 0 {
                //날짜가 클릭한 날짜와 같고, 지출/수입이 false(수입)인 데이터 개수
                return realm.objects(MyData.self).filter("date == %@ AND plusOrMinus = false", self.navigationItem.title as Any).count
            }else {
                //테이블 뷰에 셀이 없을 때 값은 0원으로 표시된다.
                dayTotalMoney.text = "0"
                dayTotalMoney.textColor = UIColor.black
                totalPlusMoney.text = " 없음"
                return 0
            }
        }
        if tableView == minusTableView {
            if realm.objects(MyData.self).filter("date == %@", self.navigationItem.title as Any).count > 0 {
                //날짜가 클릭한 날짜와 같고, 지출/수입이 true(지출)인 데이터 개수
                return realm.objects(MyData.self).filter("date == %@ AND plusOrMinus = true", self.navigationItem.title as Any).count
            }else {
                totalMinusMoney.text = " 없음"
                return 0
            }
        }
        return 0
    }
    
    //테이블 뷰 셀 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlusTableCell = tableView.dequeueReusableCell(withIdentifier: "PlusTableCell", for: indexPath) as! PlusTableCell
        //셀 커스텀
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .clear
        
        //테이블 뷰가 2개이므로 구분하기위한 조건문
        if tableView == plusTableView {
            //메인화면에서 클릭한 날짜의 데이터만 출력하기 위해서 조건문 사용
            if realm.objects(MyData.self).filter("date == %@", self.navigationItem.title as Any).count > 0 {
                //realm데이터에서 필터링한 데이터들을 따로 추출하기위한 변수선언.
                let datefiltering = realm.objects(MyData.self).filter("date == %@ AND plusOrMinus == false", self.navigationItem.title as Any)
                //변수[0].value(forKey: "") 로 추출한 데이터 불러오기. -> .value는 NS스트링 값이므로 사용x
                //대신 아래와 같은 방법 사용.
                cell.plusCellTitle.text = "\(datefiltering[indexPath.row].moneyTitle)"
                cell.plusCellMoney.text = "\(MainVC.decimalWon(value: Int(datefiltering[indexPath.row].money)!))"
                dayTotalMoney.text = "\(MainVC.decimalWon(value: dateTotalFunc()))"
//                totalPlusMoney.text = "\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: false))) 원"
//                totalMinusMoney.text = "\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: true))) 원"
                if dateTotalFunc() > 0 {
                    dayTotalMoney.text = "+\(MainVC.decimalWon(value: dateTotalFunc()))"
                    dayTotalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
                }else if dateTotalFunc() < 0 {
                    dayTotalMoney.text = "\(MainVC.decimalWon(value: dateTotalFunc()))"
                    dayTotalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
                }else if dateTotalFunc() == 0 {
                    dayTotalMoney.textColor = UIColor.black
                }
            
                if dateTotalPlusMinusMoney(bool: false) > 0 {
                    totalPlusMoney.text = " : +\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: false))) 원"
                }else {
                    totalPlusMoney.text = " 없음"
                }
                if dateTotalPlusMinusMoney(bool: true) < 0 {
                    totalMinusMoney.text = " : \(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: true))) 원"
                }else {
                    totalMinusMoney.text = " 없음"
                }
                
            }
            return cell
        }

        if tableView == minusTableView {
            //메인화면에서 클릭한 날짜의 데이터만 출력하기 위해서 조건문 사용
            if realm.objects(MyData.self).filter("date == %@", self.navigationItem.title as Any).count > 0 {
                //realm데이터에서 필터링한 데이터들을 따로 추출하기위한 변수선언.
                let datefiltering = realm.objects(MyData.self).filter("date == %@ AND plusOrMinus == true", self.navigationItem.title as Any)
                //변수[0].value(forKey: "") 로 추출한 데이터 불러오기.
                cell.minusCellTitle.text = "\(datefiltering[indexPath.row].moneyTitle)"
                cell.minusCellMoney.text = "\(MainVC.decimalWon(value: Int(datefiltering[indexPath.row].money)!))"
                dayTotalMoney.text = "\(MainVC.decimalWon(value: dateTotalFunc()))"
//                totalPlusMoney.text = "\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: false))) 원"
//                totalMinusMoney.text = "\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: true))) 원"
                if dateTotalFunc() > 0 {
                    dayTotalMoney.text = "+\(MainVC.decimalWon(value: dateTotalFunc()))"
                    dayTotalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
                }else if dateTotalFunc() < 0 {
                    dayTotalMoney.text = "\(MainVC.decimalWon(value: dateTotalFunc()))"
                    dayTotalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
                }else if dateTotalFunc() == 0 {
                    dayTotalMoney.textColor = UIColor.black
                }
                if dateTotalPlusMinusMoney(bool: false) > 0 {
                    totalPlusMoney.text = " : +\(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: false))) 원"
                }else {
                    totalPlusMoney.text = " 없음"
                }
                if dateTotalPlusMinusMoney(bool: true) < 0 {
                    totalMinusMoney.text = " : \(MainVC.decimalWon(value: dateTotalPlusMinusMoney(bool: true))) 원"
                }else {
                    totalMinusMoney.text = " 없음"
                }
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //테이블 뷰에서 삭제할때 선택된 cell의 정보를 불러오기 위해 currentcell 선언.
        let currentcell : PlusTableCell = tableView.cellForRow(at: indexPath) as! PlusTableCell
        if editingStyle == .delete {
            //realm 데이터 필터링 중복 변수 선언.
            if tableView == plusTableView {
                let plusfilterdata = realm.objects(MyData.self).filter("date == %@ AND moneyTitle == %@ AND money == %@", self.navigationItem.title as Any, MainVC.decimalToNumstring(value: currentcell.plusCellTitle.text!) as Any, MainVC.decimalToNumstring(value: currentcell.plusCellMoney.text!) as Any)
                tableView.beginUpdates()
                //삭제할 cell의 정보를 가져와 realm에서 조건 만족한 데이터 삭제
                try! realm.write {
                    if plusfilterdata.count > 1 {
                        realm.delete(plusfilterdata[0])
                    }else {
                        realm.delete(plusfilterdata)
                    }
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            if tableView == minusTableView {
                let minusfilterdata = realm.objects(MyData.self).filter("date == %@ AND moneyTitle == %@ AND money == %@", self.navigationItem.title as Any, MainVC.decimalToNumstring(value: currentcell.minusCellTitle.text!) as Any, MainVC.decimalToNumstring(value: currentcell.minusCellMoney.text!) as Any)
                tableView.beginUpdates()
                try! realm.write {
                    if minusfilterdata.count > 1 {
                        realm.delete(minusfilterdata[0])
                    }else {
                        realm.delete(minusfilterdata)
                    }
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제하기"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
