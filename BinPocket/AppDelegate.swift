//
//  AppDelegate.swift
//  SaveMoney
//
//  Created by 조성빈 on 2023/01/19.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // config 설정(이전 버전에서 다음 버전으로 마이그레이션될때 어떻게 변경될것인지)
        let config = Realm.Configuration(schemaVersion: 10) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 6 {
                                        migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
                                            newObject!["id"] = UUID().uuidString
                                        }
                                        migration.enumerateObjects(ofType: MyData.className()) { oldObject, newObject in
                                            newObject!["category"] = "비어있음"
                                        }
                                        migration.enumerateObjects(ofType: FavoriteData.className()) { oldObject, newObject in
                                            newObject!["category"] = "비어있음"
                                        }
                                    }
            
            //버전 9 -> 10 'index' 컬럼 추가
            if oldSchemaVersion < 10 {
                migration.enumerateObjects(ofType: ThemeColor.className()) {
                    oldObject, newObject in
                    newObject!["index"] = "migration index"
                }
            }
            
        }
                
                // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
                Realm.Configuration.defaultConfiguration = config
        
        //앱을 실행할 때, 색 데이터가 존재하는지 확인하는 과정
        //해당 데이터를 사용해 테마 변경 가능하기 때문에 색 데이터가 없다면 생성해주어야 함
        //Realm
        let realm = try! Realm()
        guard realm.objects(ThemeColor.self).count == 3 else {
            //realm.objects(ThemeColor.self).count가 0 혹은 0 미만일 경우
            print("색 데이터가 존재하지 않습니다. 색 데이터(빈주머니 기본 테마)를 생성합니다.")
            for i in 0...2 {
                var basicTheme = ThemeColor()
                basicTheme.backgroundColor = "kCGColorSpaceModelRGB 0.948266 0.870162 0.766148 1"
                basicTheme.textColor = "kCGColorSpaceModelRGB 0.40555 0.252178 0.0804667 1"
                basicTheme.buttonColor = "kCGColorSpaceModelRGB 0.40555 0.252178 0.0804667 1"
                basicTheme.windowColor = "kCGColorSpaceModelRGB 0.816473 0.681007 0.50497 1"
                basicTheme.index = "\(i)"
                try! realm.write {
                    realm.add(basicTheme)
                }
            }
            //색 데이터 생성 후, 앱 실행
            return true
        }
        //현재 지정색상 상태 데이터 존재유무 확인
        guard realm.objects(currentTheme.self).count == 1 else {
            var currentTheme = currentTheme()
            currentTheme.themeStatus = 0 //기본 지정색상 1로 생성.
            try! realm.write {
                realm.add(currentTheme)
            }
            return true
        }
        //색 데이터와 현재 지정색상 상태 데이터가 존재하므로 앱 실행
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

