//
//  OngoingSurveys.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct OngoingSurveys: View {
    
    //
    @Environment(\.apiService) var service: ApiService
    
    @State var selectedSurvey:SurveyItem?
    @State var showCompleteSurvey = false
    @State var showLoading = false
    
    @State var surveys = [SurveyItem]()
    
    var body: some View {
        
        LoadingView(isShowing: self.$showLoading) {
            
            List(DataContext.Shared.getSurveys(.Ongoing)) { s in
                
                VStack(alignment:.leading){
                    Text(s.title).font(.headline)
                    Text(s.desc).padding(.leading).font(.system(size:13))
                }.onTapGesture {
                    self.selectedSurvey = s
                    self.showCompleteSurvey = true
                }
            }.sheet(isPresented: self.$showCompleteSurvey, onDismiss: {
                self.showCompleteSurvey = false
            }, content: {
                CompleteSurveyView(survey:self.selectedSurvey!)
            }).navigationBarTitle("Ongoing Surveys")
                .onAppear {
                    self.showLoading = true
                    self.service.fetchSurveys { (s, list, m) in
                        if s {
                            //
                            self.surveys = list
                        }else{
                            //Fallback
                            self.surveys = DataContext.Shared.getSurveys(.Ongoing)
                        }
                        self.showLoading = false
                    }
            }
        }
    }
}

struct OngoingSurveys_Previews: PreviewProvider {
    static var previews: some View {
        OngoingSurveys()
    }
}
