//
//  SurveysView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct SurveysView: View {
    //
    @Environment(\.apiService) var service: ApiService
    //
    @State var showLoading = false
    
    var body: some View {
        
        GeometryReader { geometry in
            //
            LoadingView(isShowing: self.$showLoading) {
                VStack{
                    List {
                        NavigationLink(destination: OngoingSurveys()) {
                            VStack(alignment:.leading){
                                Text("Ongoing Surveys").font(.headline)
                                Text("View all open surveys").padding(.leading).font(.system(size:13))
                            }
                        }
                        NavigationLink(destination: ProfileView()) {
                            VStack(alignment:.leading){
                                Text("My Surveys").font(.headline)
                                Text("View surveys you have perticipated recently").padding(.leading).font(.system(size:13))
                            }
                        }
                        NavigationLink(destination: ProfileView()) {
                            VStack(alignment:.leading){
                                Text("Survey Questions").font(.headline)
                                Text("View and update survey questions").padding(.leading).font(.system(size:13))
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }.navigationBarTitle(Text("Customer Surveys"))
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
        
    }
}

struct SurveysView_Previews: PreviewProvider {
    static var previews: some View {
        SurveysView()
    }
}
