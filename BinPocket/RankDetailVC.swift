//
//  RankDetailPage.swift
//  BinPocket
//
//  Created by 조성빈 on 2023/10/03.
//

import Foundation
import UIKit
import RealmSwift

class RankDetailVC : UIViewController {
    
    @IBOutlet weak var rankDateTableView: UITableView!
    
    //realm
    var realm = try! Realm()
    
    //MainVC에서 이동해올 때 값 받아올 변수
    var categoryName : String = ""
    var currentDate : String = ""
    
    //rankDateTableView의 셀 수 관련
    var dateCountSet : Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


extension RankDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rankDateTableView {
            dateCountSet = []
            for date in realm.objects(MyData.self).filter("date contains %@") {
                dateCountSet.insert(date.date)
            }
            return dateCountSet.count
        }

        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCell : RankCellDateCell = tableView.dequeueReusableCell(withIdentifier: "RankCellDateCell", for: indexPath) as! RankCellDateCell
        
        if tableView == rankDateTableView {
            return dateCell
        }

        
        return dateCell
    }
    
    
}
