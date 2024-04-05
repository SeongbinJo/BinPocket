//
//  realmDataClass.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/29.
//

import Foundation
import RealmSwift

//Realm에 저장될 데이터 모델!
class MyData: Object {
    @objc dynamic var date = "" //'yyyy년 M월 d일' 형식으로 들어갈 예정.
    @objc dynamic var plusOrMinus = false //지출/수입 구분.  false -> 수입, true -> 지출.
    @objc dynamic var moneyTitle = ""
    @objc dynamic var money = ""
    @objc dynamic var id = ""
    @objc dynamic var category = ""
}

//자주 입력하는 내역 정보 따로 저장하기 위한 데이터 모델
class FavoriteData: Object {
    @objc dynamic var plusOrMinus = false
    @objc dynamic var moneyTitle = ""
    @objc dynamic var money = ""
    @objc dynamic var id = ""
    @objc dynamic var category = ""
}

class Category: Object {
    @objc dynamic var category = ""
    @objc dynamic var id = ""
}

