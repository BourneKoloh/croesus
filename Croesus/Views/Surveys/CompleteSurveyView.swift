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
                        ForEach(self.survey.questions){ q in
                            self.containedView(q)
                        }
                    }
                }.navigationBarTitle(Text("Complete Survey"))
                .navigationBarItems(trailing:
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
                return AnyView(Picker(selection: $model.multichoiceAnswer,
                   label: Text(q.title).font(.system(size:13))) {
                    ForEach(q.choices, id: \.self) { opt in
                        Text(opt.title).tag(opt)
                    }
                }.pickerStyle(SegmentedPickerStyle()))
            case .SingleChoice:
                return AnyView(Toggle(isOn: $model.singlechoiceAnswer,
                       label: {
                        Text(q.title).font(.system(size:13))
                }))
        default:
            return AnyView(HStack{
                Text(q.title).font(.system(size:13))
                TextField("Enter your answer ..",text: self.$model.textAnswer)
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
