////
////  RankDetailVC.swift
////  BinPocket
////
////  Created by 조성빈 on 2023/10/04.
////
//
//
//import Foundation
//import UIKit
//import RealmSwift
//
//class RankDetailVC : UIViewController {
//    
//    @IBOutlet weak var rankDetailTableView: UITableView!
//    
//    var realm = try! Realm()
//    
//    var categoryName : String = ""
//    var currentDate : String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        rankDetailTableView.delegate = self
//        rankDetailTableView.dataSource = self
//        
//    }
//    
//    func getDateCount() -> [String] {
//        var dateSet : Set<String> = []
//        for date in realm.objects(MyData.self).filter("date contains %@ AND plusOrMinus == false AND category == %@", currentDate, categoryName) {
//            dateSet.insert(date.date)
//        }
//        let dateCount = dateSet.sorted { $0 < $1 }
//        
//        var detailData : [String] = []
//        for date in dateCount {
//            for i in realm.objects(MyData.self).filter("date == %@ AND plusOrMinus == false AND category = %@", date, categoryName).count {
//                
//            }
//            detailData.append(<#T##newElement: String##String#>)
//        }
//        return dateCount
//    }
//    
//    
//}
//
//extension RankDetailVC : UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20.0
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return getDateCount().count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var dateCount : [[String],[String]] = [[],[]
//        for date in realm.objects(MyData.self).filter("date contains %@ AND plusOrMinus == false AND category == %@", currentDate, categoryName) {
//            dateCount.insert(date.date)
//        }
//        return
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//    
//    //셀을 클릭했을 때.
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
//}
