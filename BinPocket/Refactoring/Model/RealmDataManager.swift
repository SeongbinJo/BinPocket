//
//  RealmDataManager.swift
//  BinPocket
//
//  Created by 조성빈 on 5/25/24.
//

import Foundation
import RealmSwift

class RealmDataManager {
    static let manager = RealmDataManager()
    
    private var realm: Realm
    
    private var monthDataList: [MyData] // 월 별 데이터 묶음(하루 데이터 x 한달)
    private var dayDataList: [MyData] // 일 별 데이터 묶음(하루의 내역)
    private var amountMonthDataList: [Int] // 일 별 총합 금액의 묶음(월 단위)
    
    private init() {
        realm = try! Realm()
        monthDataList = []
        dayDataList = []
        amountMonthDataList = []
    }

    func getAllMyData() -> [MyData] {
        let myData = self.realm.objects(MyData.self)
        return Array(myData)
    }
    
    func getAllFavoriteData() -> [FavoriteData] {
        let favoriteData = self.realm.objects(FavoriteData.self)
        return Array(favoriteData)
    }
    
    func getAllCategories() -> [Category] {
        let categories = self.realm.objects(Category.self)
        return Array(categories)
    }
}
