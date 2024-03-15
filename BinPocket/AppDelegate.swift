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
                let config = Realm.Configuration(
                    schemaVersion: 6, // 새로운 스키마 버전 설정
                    migrationBlock: { migration, oldSchemaVersion in
                        if oldSchemaVersion < 6 {
                            // 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
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
                    }
                )
                
                // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
                Realm.Configuration.defaultConfiguration = config

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

