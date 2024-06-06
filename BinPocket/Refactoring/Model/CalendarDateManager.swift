//
//  CalendarDateManager.swift
//  BinPocket
//
//  Created by 조성빈 on 5/25/24.
//

import Foundation
import UIKit

class CalendarDateManager {
    static let manager = CalendarDateManager()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var days: [String] // 해당 달의 1일이 수요일이라면 ["", "", "", "1", "2", ..., "31"]로 저장
    
    private init() {
        days = []
        self.dateFormatter.dateFormat = "yyyy년 M월"
    }
    
    //MARK: - 달력 초기화
    func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
    }
    
    //MARK: - 1일이 무슨 요일인지?
    func weekOfFirstDay() -> Int {
        let numberOfWeekDay = self.calendar.component(.weekday, from: self.calendarDate) - 1 // 1 = 일요일 이므로 일요일을 0으로 맞춰줌.
        return numberOfWeekDay
    }
    
    //MARK: - 특정 날짜의 요일은?
    func weekOfDay(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let numberOfWeekDay = self.calendar.component(.weekday, from: dateFormatter.date(from: dateString) ?? Date()) - 1
        switch numberOfWeekDay {
        case 0:
            return "일"
        case 1:
            return "월"
        case 2:
            return "화"
        case 3:
            return "수"
        case 4:
            return "목"
        case 5:
            return "금"
        case 6:
            return "토"
        default:
            return "nil"
        }
    }
    //MARK: - 특정 달의 날짜 개수(28~31)
    func countDayInMonth() -> Int {
        let countDay = self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? 0 // for의 날짜안에 in안의 of의 개수를 반환
        return countDay
    }
    
    //MARK: - calendarNavBarStackView의 Label 업데이트
    func updateTitleLabel(_ titleLabel: UILabel) {
        let date = self.dateFormatter.string(from: self.calendarDate)
        titleLabel.text = date
    }
    
    //MARK: - WeekOfFirstDay() + countDayInMonth() => days 업데이트
    func updateDays() {
        self.days.removeAll()
        let weekOfFirstDay = self.weekOfFirstDay()
        let countOfTotalDays = weekOfFirstDay + self.countDayInMonth()
        
        for day in 0..<countOfTotalDays {
            if day < weekOfFirstDay {
                self.days.append("")
                continue
            }
            self.days.append(String(day - weekOfFirstDay + 1))
        }
    }
    
    //MARK: - days의 count
    func countOfDays() -> Int {
        let count = days.count
        return count
    }
    
    func getDays() -> [String] {
        return days
    }
    
    //MARK: - 이전 달
    func prevMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
    }
    
    //MARK: - 다음 달
    func nextMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
    }
}
