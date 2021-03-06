//
//  CompleteSurveyView.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct CompleteSurveyView: View {
    
    //
    @Environment(\.apiService) var service: ApiService
    //
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showLoading = false
    var survey: SurveyItem
    @ObservedObject var model = CompleteSurveyVM()
    
    
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
                }.navigationBarTitle(Text("Complete Survey"))
                .navigationBarItems(leading: Button(action: {
                    //
                    self.presentationMode.wrappedValue.dismiss()
                    }, label: { Text("Cancel") }),
                        trailing:
                   Button("Save") {
                    self.updateAnswers()
                   })
            }.onAppear{
                self.model.survey = self.survey
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
                    //TextField("Enter your answer ..",text: self.$model.textAnswer)
                        TextField("Enter your answer ..", text: Binding(
                            get: {
                                //Get current value ..
                                return self.model.textAnswer
                                
                            },
                            set: {newValue,oldValue in
                                //update
                                print("Set answer with \(newValue)")
                                let ans = QuestionAnswer()
                                ans.id = q.answers.count
                                ans.value = newValue
                                q.answers.append(ans)
                                //
                                self.model.textAnswer = newValue
                                return
                            }
                        ))
                    .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.lightGray), lineWidth: 2))
                }.padding(.top)
            })
        }
    }
    
    func updateAnswers(){
        //
        showLoading = true
        //
        service.submitSurvey(model) { (s,  m) in
            self.showLoading = false
            if s {
                self.presentationMode.wrappedValue.dismiss()
            }else{
                //Alert Error..
            }
        }
    }
}

struct CompleteSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSurveyView(survey: DataContext.Shared.getSurveys(.Ongoing)[0])
    }
}
