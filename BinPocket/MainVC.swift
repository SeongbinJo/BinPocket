//
//  ViewController.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import UIKit
import FSCalendar
import RealmSwift
import GoogleMobileAds
import StoreKit
import AdSupport
import AppTrackingTransparency


class MainVC: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var monthTotalMoney: UILabel!
    @IBOutlet weak var plusTotalMoney: UILabel!
    @IBOutlet weak var minusTotalMoney: UILabel!
    
    //애드몹 배너뷰
    var bannerView: GADBannerView!
    //realm
    var realm = try! Realm()
    
    //DateFormatter()
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem()
        calendarViewCustom()
        calendarView.delegate = self
        calendarView.dataSource = self
        print("mydata의 데이터 목록 : \(realm.objects(MyData.self))")
        
        //애드몹 앱 트래킹(앱추적) 얼럿
        requestTrackingAuthorization()
        
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
        SKStoreReviewController.requestReview()
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id{앱스토어ID}") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
        
    }
    
    func requestTrackingAuthorization() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { (status) in
                        switch status {
                        case .notDetermined:
                            print("notDetermined") // 결정되지 않음
                        case .restricted:
                            print("restricted") // 제한됨
                        case .denied:
                            print("denied") // 거부됨
                        case .authorized:
                            print("authorized") // 허용됨
                        @unknown default:
                            print("error") // 알려지지 않음
                        }
                    }
                }
            }
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
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "빈 주머니"
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
        calendarView.appearance.headerTitleFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 20)
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.weekdayFont = UIFont(name: "NanumBarunpenOTF-Bold", size: 17)
        calendarView.appearance.titleFont = UIFont(name: "NanumBarunpenOTF", size: 17)
        calendarView.appearance.headerDateFormat = "yyyy년 M월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.headerTitleOffset = CGPoint(x: 0.0, y: -10.0)
        calendarView.appearance.borderRadius = 0.5
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.subtitleTodayColor = .black
        calendarView.appearance.todayColor = UIColor(r: 110, g: 62, b: 4, a: 0.3)
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.subtitleDefaultColor = .black
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.subtitleSelectionColor = .black
        calendarView.appearance.subtitleFont = .systemFont(ofSize: 9)
        calendarView.appearance.subtitleOffset = CGPoint(x: 0.0, y: 4)
        calendarView.placeholderType = .none
        
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        for num in 1...6 {
            calendarView.calendarWeekdayView.weekdayLabels[num].textColor = UIColor.black
        }
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
    }
}


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
            //해당 날짜의 money들의 합계를 계산하고 return함.
            let filterdate = realm.objects(MyData.self).filter("date == %@", dateFormatter.string(from: date))
            var datetotal = 0
                for i in 0...filterdate.endIndex - 1 {
                    datetotal = datetotal + Int(filterdate[i].money)!
                }
            if datetotal > 0 {
                return "+\(datetotal)원"
            }else if datetotal == 0 {
                return "\(datetotal)원"
            }else {
                return "\(datetotal)원"
            }
        }
        
        //이번 달 총 합계 구하기.
        //현재 달력이 가르키고있는 연도, 월을 가져와 realm데이터에 이를 포함하는 데이터를 다 합하여 '이번 달 총 합계'에 출력.
        let currentPageDate = calendarView.currentPage
        let currentYear = Calendar.current.component(.year, from: currentPageDate)
        let currentMonth = Calendar.current.component(.month, from: currentPageDate)
        let currentYearMonth = "\(currentYear)년 \(currentMonth)월"
        let dateFilter = realm.objects(MyData.self).filter("date contains %@", currentYearMonth)
        let datePlusFilter = dateFilter.filter("plusOrMinus == false")
//        print("홀리뱅뱅뱅 : \(datePlusFilter)")
        let dateMinusFilter = dateFilter.filter("plusOrMinus == true")
//        print("마이너스뱅뱅뱅 : \(dateMinusFilter)")
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
            for i in 0...dateMinusFilter.endIndex - 1 {
                minusmoney = minusmoney + Int(dateMinusFilter[i].money)!
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
    
    
    //MARK - GADBannerViewDelegate 관련 메소드
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
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

