//
//  UpdateSurvey.swift
//  Croesus
//
//  Created by Bourne K on 05/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct UpdateSurveyView: View {
    
    //
    @Environment(\.apiService) var service: ApiService
    //
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showLoading = false
    
    var survey: SurveyItem
    @ObservedObject var model = UpdateSurveyVM()
    
    var body: some View {
        LoadingView(isShowing: self.$showLoading) {
            NavigationView{
                List{
                    Section(header:Text(self.survey.title).font(.headline)){
                        if self.survey.questions.count > 0 {
                            ForEach(self.survey.questions){ item in
                                self.containedView(item)
                            }
                        }else{
                            Text("This Survey has No Questions")
                        }
                    }
                }.navigationBarTitle(Text("Update Survey"))
                .navigationBarItems(leading: Button(action: {
                    //
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Cancel") }),trailing:
                   Button("Update") {
                    //self.updateAnswers()
                   })
            }.onAppear{
                //self.model.survey = self.survey
            }
        }.onAppear{
            
        }
    }
    
    //
    func containedView(_ q:SurveyQuestion) -> AnyView {
        
        switch q.type {
            case .MultipleChoice:
                return AnyView(VStack(alignment: .leading, spacing: 10){
                    Text("\(q.id+1). \(q.title)").font(.system(size:13))
                    Picker(selection: $model.multichoiceAnswer, label: Text("").frame(width: 0, height: 0, alignment: .leading)) {
                        ForEach(q.choices) { opt in
                            if self.model.multichoiceAnswer == opt.title {
                                Text(opt.title).foregroundColor(Color(UIColor.systemBlue))//.tag(opt)
                            }else{
                                Text(opt.title)//.tag(opt)
                            }
                        }
                    }.labelsHidden()
                        //.pickerStyle(WheelPickerStyle())
                        .pickerStyle(SegmentedPickerStyle())
                }.padding(.top))
            case .SingleChoice:
                return AnyView(Toggle(isOn: $model.singlechoiceAnswer,
                       label: {
                        Text("\(q.id+1). \(q.title)").font(.system(size:13))
                }).padding(.top))
        default:
            return AnyView(GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 10){
                    Text("\(q.id+1). \(q.title)").font(.system(size:13))
                    TextField("Enter your answer ..", text: Binding(
                        get: {
                            //Get current value ..
                            return q.answers[q.id].value
                            
                        },
                        set: {newValue,oldValue in
                            //update
                            q.answers[q.id].value = newValue
                            return
                        }
                    ))
                    .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.lightGray), lineWidth: 2))
                }.padding(.top)
            })
        }
    }
}

struct UpdateSurvey_Previews: PreviewProvider {
    static var previews: some View {
        UpdateSurveyView(survey: DataContext.Shared.getSurveys(.Completed)[0])
    }
}
