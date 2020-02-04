//
//  AppServices.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class AppUtils:NSObject {
    
    static func getServices() ->[AppService]{
        
        var l = [AppService]()
        
        let svc1 = AppService()
        svc1.id = 1
        svc1.name = "Summary"
        svc1.kind = .Summary
        l.append(svc1)
        
        let svc2 = AppService()
        svc2.id = 2
        svc2.name = "Questions"
        svc2.kind = .Questions
        l.append(svc2)
        
        let svc3 = AppService()
        svc3.id = 3
        svc3.name = "Profile"
        svc3.kind = .Profile
        l.append(svc3)
        
        let svc4 = AppService()
        svc4.id = 4
        svc4.name = "Surveys"
        svc4.kind = .Surveys
        l.append(svc4)
        
        return l
    }
}



