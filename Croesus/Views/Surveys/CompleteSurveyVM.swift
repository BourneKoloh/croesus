//
//  CompleteSurveyVM.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI
import Combine

class CompleteSurveyVM:ObservableObject {
    
    //
    @Environment(\.apiService) var service: ApiService
    //
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var survey: SurveyItem?
    
    var multichoiceAnswer = ""{
        didSet{
            //
            let ans = QuestionAnswer()
            ans.value = multichoiceAnswer
            //
            survey?.questions[0].answers.append(ans)
        }
    }
    var singlechoiceAnswer = false{
        didSet{
            //
            let ans = QuestionAnswer()
            ans.value = multichoiceAnswer
            //
            survey?.questions[0].answers.append(ans)
        }
    }
    var textAnswer = ""{
        didSet{
            //
            let ans = QuestionAnswer()
            ans.value = multichoiceAnswer
            //
            survey?.questions[0].answers.append(ans)
        }
    }
}
