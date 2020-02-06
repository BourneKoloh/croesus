//
//  DataMocks.swift
//  Croesus
//
//  Created by Bourne K on 06/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class DataMocks:NSObject {
    
    static func getDemoSurveys() -> [SurveyItem]{
        
        var list = [SurveyItem]()
        
        let s1 = SurveyItem()
        s1.id = 1
        s1.kind = .Ongoing
        s1.title = "Sample Survey 1"
        s1.desc = "A sample demo survey for testing ongoing surveys with multiple choice questions"
        list.append(s1)
        
        let q0 = SurveyQuestion()
        q0.id = 0
        q0.type = .SingleChoice
        q0.title = "How do you like our banking services?"
        s1.questions.append(q0)
        
        let q1 = SurveyQuestion()
        q1.id = 1
        q1.type = .MultipleChoice
        q1.title = "When was the last time you visited your branch?"
        
        let a1 = QuestionChoice()
        a1.id = 1
        a1.title = "This Week"
        a1.value = "TW"
        q1.choices.append(a1)
        
        let a2 = QuestionChoice()
        a2.id = 2
        a2.title = "Last Week"
        a2.value = "LW"
        q1.choices.append(a2)
        
        let a3 = QuestionChoice()
        a3.id = 3
        a3.title = "Last Month"
        a3.value = "LM"
        q1.choices.append(a3)
        
        let a4 = QuestionChoice()
        a4.id = 4
        a4.title = "Earlier"
        a4.value = "E"
        q1.choices.append(a4)
        
        s1.questions.append(q1)
        
        let q2 = SurveyQuestion()
        q2.id = 2
        q2.type = .Text
        q2.title = "If the choice above is 'Earlier', kindly tell us why,"
        s1.questions.append(q2)
        
        let s2 = SurveyItem()
        s2.id = 2
        s2.kind = .Ongoing
        s2.title = "Sample Survey 2"
        s2.desc = "A sample demo survey for testing ongoing surveys text answers only"
        list.append(s2)
        
        //
        let s3 = SurveyItem()
        s3.id = 3
        s3.kind = .Completed
        s3.title = "Sample Survey 2"
        s3.desc = "A sample demo survey for testing completed surveys text answers only"
        list.append(s3)
        
        return list
    }
}
