//
//  Cache.swift
//  Croesus
//
//  Created by Bourne K on 06/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class AppCache: NSObject {
    private static let STORE_NAME = "app_cache"
    
    private static var AppStore:[String:Any]{
        get{
            if let userInformation = UserDefaults.standard.dictionary(forKey: STORE_NAME){
                //Old value
                return userInformation
            }else{
                //New Instance
                let userInfo = [String:Any]()
                //
                UserDefaults.standard.set(userInfo, forKey: STORE_NAME)
                //
                return userInfo
            }
        }
        set{
            //Overwrite
            UserDefaults.standard.set(newValue, forKey: STORE_NAME)
        }
    }
    
    static func getBool(_ key:String) -> Bool{
        return AppStore[key] as? Bool ?? false
    }
    
    static func storeBool(_ key:String, _ value:Bool) -> Bool{
        AppStore[key]  = value
        return true
    }
    
    static func getString(_ key:String) -> String?{
        return AppStore[key] as? String
    }
    
    static func storeString(_ key:String, _ value:String) -> Bool{
        AppStore[key]  = value
        return true
    }
    
    static func getDate(_ key:String) -> Date?{
        let df = DateFormatter()
        df.dateFormat = DataContext.DATE_FORMAT
        return df.date(from: AppStore[key] as? String ?? "")
    }
    
    static func storeDate(_ key:String, _ value:Date){
        let df = DateFormatter()
        df.dateFormat = DataContext.DATE_FORMAT
        //
        AppStore[key]  = df.string(from: value)
    }
}


struct CacheKeys {
    static let LastBuckup = "last_buckup"
    static let LastSync = "last_sync"
    static let DEBUG = "debug"
}
