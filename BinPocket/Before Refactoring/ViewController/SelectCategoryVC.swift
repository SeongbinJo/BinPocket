//
//  SelectCategoryVC.swift
//  BinPocket
//
//  Created by 조성빈 on 2023/09/07.
//

import Foundation
import UIKit
import RealmSwift

class SelectCategoryVC : UIViewController {
    


    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var makeCategoryButton: UIButton!
    @IBOutlet weak var categoryTableBox: Borderview!
    
    //Realm
    var realm = try! Realm()
    
    //Realm 데이터베이스 변경될때 이용할 토큰.
    var notificationToken : NotificationToken?
    
    //AddListVC의 카테고리 Label에 클릭한 카테고리 Name 데이터 전달.
    var selectedCategory: ((_ category: String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //카테고리 콜렉션 뷰 관련
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        //Realm 카테코리 데이터 업데이트 될 때마다 테이블 뷰 리로드.
        notificationToken = realm.observe({ (noti, realm) in
            self.categoryTableView.reloadData()
        })
        

        
    }
    
    
    @IBAction func makeCategoryButtonAction(_ sender: Any) {
        let makeCategoryAlert = UIAlertController(title: "카테고리 만들기", message: "생성할 카테고리 이름을 지어주세요!", preferredStyle: .alert)
        
        let makeButton = UIAlertAction(title: "만들기", style: .default) { _ in
            print("만들기 누름.")
            guard let textField = makeCategoryAlert.textFields?.first else { return print("카테고리 이름 오류1") }
            //카테고리 추가 alert에서 텍스트필드에 값이 담겨있지 않을 경우
            guard textField.text != "" else {
                let nilCategoryAlert = UIAlertController(title: "알림!", message: "카테고리 이름이 비어있습니다!", preferredStyle: .alert)
                self.present(nilCategoryAlert, animated: true, completion: nil)
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in nilCategoryAlert.dismiss(animated: true, completion: nil)} )
                return print("카테고리 이름 오류2")
            }
            guard self.realm.objects(Category.self).filter("category == %@", textField.text).isEmpty else {
                let duplicateCategoryAlert = UIAlertController(title: "알림!", message: "이미 존재하는 카테고리입니다!", preferredStyle: .alert)
                self.present(duplicateCategoryAlert, animated: true, completion: nil)
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in duplicateCategoryAlert.dismiss(animated: true, completion: nil)} )
                return print("이미 존재하는 카테고리")
            }
            //정상적으로 텍스트필드에 값이 담기고, <만들기>를 눌렀을 경우. => Realm에 저장
            let categoryList = Category()
            categoryList.category = textField.text!
            categoryList.id = UUID().uuidString
            try! self.realm.write {
                self.realm.add(categoryList)
            }
            print("방금 추가된 카테고리 : \(self.realm.objects(Category.self))")
        }
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("취소 누름.")
        }
        
        makeCategoryAlert.addTextField { Text in
            Text.placeholder = "카테고리 이름을 입력하세요"
        }
        makeCategoryAlert.addAction(cancelButton)
        makeCategoryAlert.addAction(makeButton)
        
        present(makeCategoryAlert, animated: true)
    }
    

    
    
    
    
}

// 콜렉션 뷰 Delegate - 액션 관련된 것들, DataSource - 데이터 관련된 것들
extension SelectCategoryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Category.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CategoryTableViewCell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        
        let categoryArray = realm.objects(Category.self)
        
        print(cell)
        
        cell.categoryName.text = categoryArray[indexPath.row].category
        cell.id = categoryArray[indexPath.row].id
        
        return cell
    }
    
    //셀 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currentCell : CategoryTableViewCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        if editingStyle == .delete {
            let categoryData = realm.objects(Category.self).filter("id == %@", currentCell.id)
            tableView.beginUpdates()
            try! realm.write {
                realm.delete(categoryData)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print("삭제한 뒤의 남은 카테고리 데이터 목록 : \(self.realm.objects(Category.self))")
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제하기"
    }
    
    //셀 클릭 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentcell: CategoryTableViewCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        let selectedCell = realm.objects(Category.self).filter("id == %@", currentcell.id)
        self.selectedCategory!(currentcell.categoryName.text!)
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
    }

}
