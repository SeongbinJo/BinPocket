//
//  SettingVC.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/02/10.
//

import Foundation
import UIKit
import RealmSwift

class SettingVC : UIViewController {
    
    
    @IBOutlet weak var settingTableView: UITableView!
    
    let settingTitleList : [String] = ["도움말", "Contact App Developer"]
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviItem()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        
        
    }
    
    //네비게이션 바
    func naviItem() {
        self.navigationItem.title = "설정"
    }
    
}

extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingtableviewCell = tableView.dequeueReusableCell(withIdentifier: "SettingtableviewCell", for: indexPath) as! SettingtableviewCell
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 10
        cell.settingLabel.text = settingTitleList[indexPath.row]
        
        return cell
    }
    
    //셀을 클릭했을 때.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //셀을 클릭하면 이펙트 나왔다 사라짐.
        tableView.deselectRow(at: indexPath, animated: true)
        guard let helppage = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as? UIViewController else { return }
 
        guard let contactpage = self.storyboard?.instantiateViewController(withIdentifier: "ContactVC") as? UIViewController else { return }

        if indexPath.row == 0 {
            self.present(helppage, animated: true)
        }else if indexPath.row == 1 {
            self.present(contactpage, animated: true)
        }
        print(type(of: indexPath.row))
    }
    
}
