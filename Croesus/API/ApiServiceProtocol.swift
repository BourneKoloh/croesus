//
//  ApiService.swift
//  Croesus
//
//  Created by Bourne K on 05/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct ApiServiceKey: EnvironmentKey {
    static let defaultValue: ApiService = ApiServiceImpl.Instance
}

extension EnvironmentValues {
    var apiService: ApiService {
        get {
            return self[ApiServiceKey.self]
        }
        set {
            self[ApiServiceKey.self] = newValue
        }
    }
}

protocol ApiService : class {
    
    //MARK: -
    func fetchSurveys(_ completion:@escaping(_ s:Bool, _ services : [SurveyItem], _ msg:String?)->Swift.Void) -> Swift.Void

    //MARK: -
    func syncData(_ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void) -> Swift.Void
    
    //MARK: -
    func submitSurvey(_ model:CompleteSurveyVM, _ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void) -> Swift.Void
}
