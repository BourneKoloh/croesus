//
//  SurveyQuestionEntry.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

enum AnswerKind:Int{
    case Text,SingleChoice,MultipleChoice
}

class SurveyQuestion:NSObject,Identifiable {
    var id = 0
    var title = ""
    var type = AnswerKind.Text
    var dateAdded:Date?
    var choices = [QuestionChoice]()
    var answers = [QuestionAnswer]()
}


class QuestionAnswer: NSObject,Identifiable {
    var id = 0
    var value = ""
    var dateAdded:Date?
}

class QuestionChoice: Identifiable,Hashable{
    
    static func == (lhs: QuestionChoice, rhs: QuestionChoice) -> Bool {
        return lhs.value == rhs.value && rhs.title == lhs.value && rhs.value == lhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(value)
    }
    var id = 0
    var title = ""
    var value = ""
    var dateAdded:Date?
}
