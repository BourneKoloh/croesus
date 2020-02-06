//
//  QuestionsView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct QuestionsView: View {
    //
    @Environment(\.apiService) var service: ApiService
    
    @State var model = QuestionVM()
    
    @State var showLoading = false
    @State var showAlert = false
    @State var showSuccess = false
    
    @State var failureMessage = ""
    var questionKinds = ["Multi Choice","Single Choice","Text"]
    
    var SuccessSheet: ActionSheet {
        ActionSheet(
            title: Text("Operation Success"),
            message: Text("Question Submitted Successfully"),
            buttons: [
                .default(Text("Dismiss"), action: {
                    self.showSuccess = false
                })
            ])

    }
    
    var body: some View {
        
        GeometryReader { geometry in
            //
            LoadingView(isShowing: self.$showLoading) {
                Form {
                    Section(header: Text("QUESTION DETAILS").font(.headline)) {
                            
                        HStack(alignment: .bottom, spacing:20){
                            Text("Title :")
                            TextField("Enter Question Type ..",text: self.$model.questionTitle)
                        }
                        HStack(alignment: .bottom, spacing:20){
                            Text("Description :")
                            TextField("Enter Description ..", text: self.$model.questionDesc)
                        }
                        VStack(alignment: .leading, spacing:10){
                            Text("Question Kind :")
                            Picker(selection: self.$model.questionKind, label: Text("")) {
                                ForEach(self.questionKinds, id: \.self) { opt in
                                    Text(opt)
                                }
                            }.labelsHidden()
                            //    .pickerStyle(WheelPickerStyle())
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: geometry.size.width, height: 30, alignment: .leading)
                        }
                        
                    }
                }
            }.actionSheet(isPresented: self.$showSuccess) {
                self.SuccessSheet
            }.alert(isPresented: self.$showAlert) { () -> Alert in
                //
                return Alert(title: Text("Operation Failed."), message: Text("Question could NOT be submitted.\n\(self.failureMessage)"),
                      primaryButton: .default(Text("TRY-AGAIN"), action: {
                        self.showAlert = false
                        self.attemptSave()
                      }),
                      secondaryButton: .default(Text("Dismiss"), action: {
                          self.showAlert = false
                      
                        })
                )
            }.navigationBarTitle(Text("Capture new Question"))
                .navigationBarItems(trailing:
            Button("Save") {
                self.attemptSave()
            })
        }
    }
    
    func attemptSave(){
        //
        showLoading = true
        service.submitQuestion(model){status,message in
            if status {
                //
                self.showSuccess = true
            }else{
                self.failureMessage = message ?? ""
                //
                self.showAlert = true
            }
        }
        self.showLoading = false
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}
