//
//  ViewController.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import UIKit
import FSCalendar
import RealmSwift
//import SwiftUI


class MainVC: UIViewController {
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var monthTotalMoney: UILabel!
    @IBOutlet weak var plusTotalMoney: UILabel!
    @IBOutlet weak var minusTotalMoney: UILabel!
    @IBOutlet weak var plusRankTableView: UITableView!
    @IBOutlet weak var minusRankTableView: UITableView!
    
    //realm
    var realm = try! Realm()
    
    //DateFormatter()
    let dateformatter = DateFormatter()
    
    //Realm 데이터베이스가 변경될때 이용할 토큰.
    var mydataNotiToken : NotificationToken?

    
    //현재 저장된 데이터들 중 한번이라도 사용되고있는 카테고리의 종류 담아내는 부분
    var plusCategoryCount : Set<String> = []
    var minusCategoryCount : Set<String> = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem()
        calendarViewCustom()
        calendarView.delegate = self
        calendarView.dataSource = self
        plusRankTableView.delegate = self
        plusRankTableView.dataSource = self
        minusRankTableView.delegate = self
        minusRankTableView.dataSource = self
        
 
        //notificationToken를 사용할 대상
        var mydata = realm.objects(MyData.self)
        //데이터베이스가 변경될때마다 테이블 뷰 리로드하는 코드.
        mydataNotiToken = mydata.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self!.plusRankTableView.reloadData()
                self!.minusRankTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                print("MyData 데이터 변경 감지됨")
                self!.plusRankTableView.reloadData()
                self!.minusRankTableView.reloadData()
            case .error(let error):
                print("\(error)")
            }
        }
        
   
        
    }
    
    
    
    //MainVC 나타날때
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
        //notification 명령 수신.
        NotificationCenter.default.addObserver(self, selector: #selector(goToMyMonthCalendar(notification: )), name: .goToMyMonth, object: nil)
    }
    
    //notification 명령 수신할 때 사용될 함수.
    //명령 발신 때 보낸 object값도 같이 받음. notification : Notification
    @objc func goToMyMonthCalendar(notification : Notification) {
        var getvalue = notification.object! //yyyy년 M월 스트링값.
        //yyyy년 M월 스트링 -> yyyy년 M월 date 형태로 타입변환.
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년 M월"
        getvalue = dateformatter.date(from: getvalue as! String)!
        //타입변환된 date로 달력 이동.
        self.calendarView.setCurrentPage(getvalue as! Date, animated: true)
    }
    
    
    //네비게이션 바
    func naviItem() {
        let goToTotalPageBtn = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(goToTotalListPage(sender:)))
        let goToCurrentDateBtn = UIBarButtonItem(image: UIImage(systemName: "t.square"), style: .plain, target: self, action: #selector(currentPageBtn(sender:)))
        let settingBtn = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingPageBtn(sender:)))
        self.navigationItem.rightBarButtonItems = [goToTotalPageBtn, goToCurrentDateBtn]
        self.navigationItem.leftBarButtonItems = [settingBtn]
        self.navigationItem.title = "빈 주머니"
        self.navigationController?.navigationBar.tintColor = .black
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    //네비게이션 버튼 -> 월별 지출 현황
    @objc func goToTotalListPage(sender: UIBarButtonItem) {
        guard let mainviewpage = self.storyboard?.instantiateViewController(withIdentifier: "TotalListVC") as? TotalListVC else { return }
        self.present(mainviewpage, animated: true)
    }
    //네비게이션 버튼 -> 당월 달력 이동
    @objc func currentPageBtn(sender: UIBarButtonItem) {
        self.calendarView.setCurrentPage(Date(), animated: true)
    }
    //네비게이션 버튼 -> 설정 페이지 이동
    @objc func settingPageBtn(sender: UIBarButtonItem) {
        let settingpage = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(settingpage, animated: true)
    }

    
    
    //FScalendar 커스텀
    func calendarViewCustom() {

        calendarView.appearance.headerTitleFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 17)
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.weekdayFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 17)
        calendarView.appearance.titleFont = UIFont(name: "NanumBarunpenOTF", size: 17)
        calendarView.appearance.headerDateFormat = "yyyy년 M월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.headerTitleOffset = CGPoint(x: 0.0, y: -10.0)
        calendarView.appearance.borderRadius = 0.5
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.subtitleTodayColor = .black
        calendarView.appearance.todayColor = .systemGray3
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.subtitleDefaultColor = .black
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.subtitleSelectionColor = .black
        calendarView.appearance.subtitleFont = .systemFont(ofSize: 9)
        calendarView.appearance.subtitleOffset = CGPoint(x: 0.0, y: 4)
        calendarView.placeholderType = .none
        
        for num in 0..<7 {
            if num == 0 {
                calendarView.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
            }else if num == 6 {
                calendarView.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
            }else {
                calendarView.calendarWeekdayView.weekdayLabels[num].textColor = UIColor.black
            }
        }
    }
    
    //해당 월의 지출, 수입을 구하는 함수
    func totalMoney(plusOrMinus: Bool) -> Int {
        //현재 년도, 월 알아내는 부분
        let currentYear = Calendar.current.component(.year, from: calendarView.currentPage)
        let currentMonth = Calendar.current.component(.month, from: calendarView.currentPage)
        let currentYearMonth = "\(currentYear)년 \(currentMonth)월"
        
        var money : Int = 0
        
        let monthData = realm.objects(MyData.self).filter("date contains %@ AND plusOrMinus == %@", currentYearMonth, plusOrMinus)
        for data in monthData {
            money = money + Int(data.money)!
        }
        
        return money
    }

    
    //지출, 수입 순위 테이블 셀에 넣을 값들 구하는 함수
    func rankData(plusOrMinus : Bool) -> Array<(key: String, value: Double)> {
        //현재 년도, 월 알아내는 부분
        let currentYear = Calendar.current.component(.year, from: calendarView.currentPage)
        let currentMonth = Calendar.current.component(.month, from: calendarView.currentPage)
        let currentYearMonth = "\(currentYear)년 \(currentMonth)월"
        
        var dataSet : Set<String> = [] //사용된 카테고리를 모으는 set
        var dataDic : [String : Double] = [:] //사용된 카테고리 별 차지하는 %를 담을 Dicionary
        
        var monthTotalMoney : Double = 0.0 //현재 달의 지출, 수입의 총 합을 담을 변수
        var categoryMoney : Double = 0.0 //사용된 카테고리의 지출, 수입의 총 합을 담을 변수
        var categoryPercentage : Double = 0.0 //카테고리 별 차지하는 퍼센테이지
        
        //해당 월의 지출/수입이 있는 데이터들을 모아둔 변수
        let monthData = realm.objects(MyData.self).filter("date contains %@ AND plusOrMinus == %@", currentYearMonth, plusOrMinus)
        
        //해당 달의 수입, 지출의 총 합 구하는 for문
        for data in monthData {
            monthTotalMoney = monthTotalMoney + (Double(data.money) ?? 0.0) //총 액 구하는 부분
            dataSet.insert(data.category) //사용된 카테고리 종류별 모으는 부분
        }
        
        //종류별로 모은 카테고리가 지출/수입의 총 액 구하는 for문
        for data in dataSet {
            categoryMoney = 0.0
            categoryPercentage = 0.0
            for money in monthData.filter("category == %@", data) {
                categoryMoney = categoryMoney + (Double(money.money) ?? 0.0) //카테고리 별 지출/수입 총 액 구하는 부분
            }
            categoryPercentage = categoryMoney / monthTotalMoney * 100
            dataDic[data] = categoryPercentage
        }
        let result = dataDic.sorted { $0.1 > $1.1 }
        return result
    }
    

}//MainVC


//FScalendar 클릭 이벤트
extension MainVC : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateformatter.dateFormat = "yyyy년 M월 d일"
        print("선택한 날짜 : \(dateformatter.string(from: date))")

        // 뷰 이동.
        let secondview = self.storyboard?.instantiateViewController(withIdentifier: "ViewlistVC") as! ViewlistVC
        secondview.selectdate = dateformatter.string(from: date)
        self.navigationController?.pushViewController(secondview, animated: true)
    }
    
}

//fscalendar subtitle
extension MainVC : FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //dateformat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        //date 값(String)이 realm 데이터의 date에 1개 이상 있을시 서브타이틀 생성.
        if realm.objects(MyData.self).filter("date == %@", dateFormatter.string(from: date)).count > 0 {
            self.plusRankTableView.reloadData()
            self.minusRankTableView.reloadData()
            //해당 날짜의 money들의 합계를 계산하고 return함.
            let filterdate = realm.objects(MyData.self).filter("date == %@", dateFormatter.string(from: date))
            var datetotal = 0
            for money in filterdate {
                datetotal = datetotal + Int(money.money)!
            }
            if datetotal > 0 {
//                calendarView.appearance.subtitleDefaultColor = .red
                return "+\(datetotal)원"
            }else if datetotal == 0 {
                return "\(datetotal)원"
            }else {
//                calendarView.appearance.subtitleDefaultColor = .blue
                return "\(datetotal)원"
            }
        }
        self.plusRankTableView.reloadData()
        self.minusRankTableView.reloadData()
        
        //이번 달 총 합계 구하기.
        //현재 달력이 가르키고있는 연도, 월을 가져와 realm데이터에 이를 포함하는 데이터를 다 합하여 '이번 달 총 합계'에 출력.
        let currentPageDate = calendarView.currentPage
        let currentYear = Calendar.current.component(.year, from: currentPageDate)
        let currentMonth = Calendar.current.component(.month, from: currentPageDate)
        let currentYearMonth = "\(currentYear)년 \(currentMonth)월"
        let dateFilter = realm.objects(MyData.self).filter("date contains %@", currentYearMonth)
        let datePlusFilter = dateFilter.filter("plusOrMinus == false")
        let dateMinusFilter = dateFilter.filter("plusOrMinus == true")
        //해당 월의 합계금액을 저장하기위한 변수.
        var monthmoney = 0
        var plusmoney = 0
        var minusmoney = 0
        //조건에 맞는 데이터가 한 개 이상 있다면, 그 조건에 맞는 money들의 총 합계를 보여주고 0개라면 0원 보여줌.
        if dateFilter.count > 0 {

            for i in 0...dateFilter.endIndex - 1 {
                monthmoney = monthmoney + Int(dateFilter[i].money)!
            }

            if monthmoney > 0 {
                monthTotalMoney.text = "+\(MainVC.decimalWon(value: monthmoney))"
                monthTotalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
            }else if monthmoney < 0 {
                monthTotalMoney.text = "\(MainVC.decimalWon(value: monthmoney))"
                monthTotalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
            }
                
        }else {
            monthTotalMoney.text = "0"
            monthTotalMoney.textColor = UIColor.black
        }
        //해당 달 수입 합계.
        if datePlusFilter.count > 0 {
            for i in 0...datePlusFilter.endIndex - 1 {
                plusmoney = plusmoney + Int(datePlusFilter[i].money)!
            }

            if plusmoney > 0 {
                plusTotalMoney.text = "+\(MainVC.decimalWon(value: plusmoney))"
                plusTotalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
            }else if plusmoney < 0 {
                plusTotalMoney.text = "\(MainVC.decimalWon(value: plusmoney))"
                plusTotalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
            }
                
        }else {
            plusTotalMoney.text = "0"
            plusTotalMoney.textColor = UIColor.black
        }
        
        //해당 달 지출 합계.
        if dateMinusFilter.count > 0 {
            for money in dateMinusFilter {
                minusmoney = minusmoney + Int(money.money)!
            }

            if minusmoney > 0 {
                minusTotalMoney.text = "+\(MainVC.decimalWon(value: minusmoney))"
                minusTotalMoney.textColor = UIColor(r: 233, g: 81, b: 81, a: 1)
            }else if minusmoney < 0 {
                minusTotalMoney.text = "\(MainVC.decimalWon(value: minusmoney))"
                minusTotalMoney.textColor = UIColor(r: 61, g: 137, b: 249, a: 1)
            }
                
        }else {
            minusTotalMoney.text = "0"
            minusTotalMoney.textColor = UIColor.black
        }
        return "-"
    }
    
    
    //숫자 세자리 마다 , 찍어주는 함수.
    static func decimalWon(value: Int) -> String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: value))!
            return result
        }
    // , 들어있는 값을 , 빼주는 함수.
    static func decimalToNumstring(value: String) -> String {
        let result = value.components(separatedBy: ",").joined()
        return result
    }
    
    
   
}

extension MainVC : UITableViewDelegate, UITableViewDataSource {
    
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == plusRankTableView {
            if rankData(plusOrMinus: false).count > 0 {
                return rankData(plusOrMinus: false).count
            }
            return 0
        }
        if tableView == minusRankTableView {
            if rankData(plusOrMinus: true).count > 0 {
                return rankData(plusOrMinus: true).count
            }
            return 0
        }
        return 0
    }

    //셀 표현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RankTableCell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! RankTableCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        
        let plusMoney : Int = self.totalMoney(plusOrMinus: false)
        let minusMoney : Int = self.totalMoney(plusOrMinus: true)
        let monthMoney : Int = plusMoney + minusMoney
        self.plusTotalMoney.text = "\(MainVC.decimalWon(value: plusMoney))"
        self.plusTotalMoney.textColor = plusMoney > 0 ? UIColor(r: 233, g: 81, b: 81, a: 1) : UIColor.black
        self.minusTotalMoney.text = "\(MainVC.decimalWon(value: minusMoney))"
        self.minusTotalMoney.textColor = minusMoney < 0 ? UIColor(r: 61, g: 137, b: 249, a: 1) : UIColor.black
        self.monthTotalMoney.text = "\(MainVC.decimalWon(value: monthMoney))"
        self.monthTotalMoney.textColor = monthMoney > 0 ? UIColor(r: 233, g: 81, b: 81, a: 1) : monthMoney < 0 ? UIColor(r: 61, g: 137, b: 249, a: 1) : UIColor.black

        if tableView == plusRankTableView {
            if rankData(plusOrMinus: false).count > 0 {
                cell.plusRankNum.text = String(indexPath.row + 1)
                cell.plusCategory.text = rankData(plusOrMinus: false)[safe: indexPath.row]?.key
                cell.plusPercentage.text = "[\(String(format: "%.1f", rankData(plusOrMinus: false)[safe: indexPath.row]?.value ?? 0.0))]"
            }
            return cell
        }

        if tableView == minusRankTableView {
            if rankData(plusOrMinus: true).count > 0 {
                cell.minusRankNum.text = String(indexPath.row + 1)
                cell.minusCategory.text = rankData(plusOrMinus: true)[safe: indexPath.row]?.key
                cell.minusPercentage.text = "[\(String(format: "%.1f", rankData(plusOrMinus: true)[safe: indexPath.row]?.value ?? 0.0))]"
            }
            return cell
        }

        return cell
    }

}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
