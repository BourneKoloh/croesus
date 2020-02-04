//
//  AppService.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

enum AppServiceKind:Int{
    case Summary,Questions,Profile,Surveys,None
}

class AppService:NSObject,Identifiable{
    var id = 0
    var name = ""
    var kind:AppServiceKind
    
    override init(){
        kind = .None
    }
}
