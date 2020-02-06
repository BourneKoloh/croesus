//
//  SurveyItem.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

enum SurveyKind:Int{
    case Ongoing,Completed,All
}
class SurveyItem: NSObject,Identifiable {
    var id = 0
    var title = ""
    var desc = ""
    var dateAdded:Date?
    var kind = SurveyKind.Completed
    var questions = [SurveyQuestion]()
}
