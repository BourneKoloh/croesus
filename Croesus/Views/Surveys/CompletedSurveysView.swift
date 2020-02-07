//
//  SurveysView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct CompletedSurveysView: View {
    //
    @Environment(\.apiService) var service: ApiService
    //
    @State var showLoading = false
    @State var showUpdateSurvey = false
    @State var selectedSurvey:SurveyItem?
    
    @State var surveys = DataMocks.getDemoSurveys().filter({ (s) -> Bool in
        return s.kind == .Completed
    })
    
    @State var showAlert = false
    @State var showSheet = false
    
    @State var failureMessage = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            //
            LoadingView(isShowing: self.$showLoading) {
                       
                       List {
                        Section(header:Text("Completed Surveys")){
                            ForEach(self.surveys) { s in
                               VStack(alignment:.leading){
                                   Text(s.title).font(.headline)
                                   Text(s.desc).padding(.leading).font(.system(size:13))
                               }.onTapGesture {
                                   self.selectedSurvey = s
                                   self.showUpdateSurvey = true
                               }
                            }
                        }
                       }.sheet(isPresented: self.$showUpdateSurvey, onDismiss: {
                           self.showUpdateSurvey = false
                       }, content: {
                           UpdateSurveyView(survey:self.selectedSurvey!)
                       })
                
            }
            
        }.navigationBarTitle("My Surveys")
            .onAppear {
                self.showLoading = true
                self.service.fetchSurveys { (s, list, m) in
                     if s {
                           //
                           self.surveys = list
                       }else{
                           //Fallback
                           self.surveys = DataContext.Shared.getSurveys(.Completed)
                        //
                            if self.surveys.isEmpty && AppCache.getBool(CacheKeys.DEBUG){
                                self.surveys = DataMocks.getDemoSurveys().filter({ (s) -> Bool in
                                    return s.kind == .Completed
                                })
                            }
                       }
                       self.showLoading = false
                }
        }
        //.navigationBarTitle(Text("Customer Surveys"))
        .navigationBarItems(trailing:
           Button("Sync") {
            self.showLoading = true
            self.service.syncData { (s, m) in
                
                if !s {
                    //Alert Failed.
                }
                self.showLoading = false
            }
           })
            .alert(isPresented: self.$showAlert) { () -> Alert in
               //
               return Alert(title: Text("SYNC. FAILED"), message: Text("Data sync with backed service has failed.\n\(failureMessage)"),
                     primaryButton: .default(Text("TRY-AGAIN"), action: {
                       self.showAlert = false
                       self.attemptSync()
                     }),
                     secondaryButton: .default(Text("Dismiss"), action: {
                         self.showAlert = false
                     
                       })
               )
           }
           .actionSheet(isPresented: self.$showSheet) {
                return ActionSheet(title: Text("SYNC SUCCESS"), message: Text("Data Synchronized successfuly"), buttons: [.default(Text("Dismiss"), action: {
                                     self.showSheet = false
                                   })])
           }
        
    }
    
    func attemptSync(){
        //
        showLoading = true
        service.syncData(){status,message in
            //
            if status {
                //
                self.showSheet = true
            }else{
                self.failureMessage = message ?? ""
                self.showAlert = true
            }
            self.showLoading = false
        }
    }
}

struct SurveysView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedSurveysView()
    }
}
