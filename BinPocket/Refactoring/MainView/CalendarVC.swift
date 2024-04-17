//
//  CalendarVC.swift
//  BinPocket
//
//  Created by 조성빈 on 3/27/24.
//

import Foundation
import UIKit
import FSCalendar
import RealmSwift

class CalendarVC: UIViewController {
    

    @IBOutlet weak var calendarView: FSCalendar!
//    @IBOutlet weak var plusRankTableView: UITableView!
//    @IBOutlet weak var minusRankTableView: UITableView!
    
    //Realm
    let realm = try! Realm()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "달력 만드는 중"
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarViewCustom()
        
//        plusRankTableView.delegate = self
//        plusRankTableView.dataSource = self
//        minusRankTableView.delegate = self
//        minusRankTableView.dataSource = self
        print("CalendarVC - viewDidLoad() 호출됨")
        
        
    }
    
    
    private func calendarViewCustom() {
        calendarView.appearance.headerDateFormat = "yyyy년 M월" // 월/년 -> 년/월
        calendarView.appearance.headerTitleFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 17) //ㅇㅇㅇㅇ년 ㅇㅇ월 글꼴
        calendarView.appearance.weekdayFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 17) //일-토 글꼴
        calendarView.appearance.titleFont = UIFont(name: "NanumBarunpenOTF", size: 15)
        calendarView.appearance.headerMinimumDissolvedAlpha = 0 // 이전, 다음 달 표시 제거
        calendarView.appearance.headerTitleColor = .black // 년/월 색상
        calendarView.appearance.selectionColor = .clear // 선택한 날짜의 배경 색상
        calendarView.appearance.titleSelectionColor = .black // 선택한 날짜의 색상
        calendarView.appearance.todayColor = .systemGray3 // 오늘 날짜 배경 색상
        calendarView.appearance.borderRadius = 0.5 // 오늘 날짜 배경 Radius
        calendarView.appearance.titleOffset = CGPoint(x: 0, y: 6) // 날짜 위치
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.subtitleTodayColor = .black
        calendarView.appearance.subtitleSelectionColor = .black
        calendarView.placeholderType = .none
        calendarView.appearance.subtitleDefaultColor = .black // 부제목 색상
        calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 20) // 부제목 위치
        
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
    
}

extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        print("선택한 날짜 : \(dateFormatter.string(from: date))")
    }
}

extension CalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let datas = realm.objects(MyData.self).filter("date == %@", dateFormatter.string(from: date))
        var moneyInDay = 0
        if datas.count > 0 {
            for data in datas {
                moneyInDay += Int(data.money) ?? 0
            }
            if moneyInDay > 0 {
                return "+\(moneyInDay)원"
            }else {
                return "\(moneyInDay)원"
            }
        }else {
            return "-"
        }
            
        
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryRankTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryRankTableViewCell", for: indexPath) as! CategoryRankTableViewCell
        
        return cell
    }
    
    
}
