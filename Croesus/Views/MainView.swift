//
//  ContentView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI
enum ApiAction:Int{
    case BUCKUP,SYNC,NONE
}
struct ContentView: View {
    //
    @Environment(\.apiService) var service: ApiService
    
    let dateFormatter = DateFormatter()
    
    @State var showLoading = false
    @State var showAlert = false
    @State var showSheet = false
    @State var action = ApiAction.NONE
    
    @State var failureMessage = ""
    
    init(){
        //
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
        //
        dateFormatter.dateFormat = "dd MMM yyyy"
    }
    
    var body: some View {
        //
        LoadingView(isShowing: self.$showLoading) {
            NavigationView {
                //
                VStack{
                    List {
                        Section(header:Text("Summary")){
                            VStack(alignment: .leading, spacing: 10) {
                                HStack{
                                    Text("Completed Surveys").font(.system(size:15))
                                    Spacer()
                                    Text("5").font(.system(size:15))
                                }
                                HStack{
                                    Text("Ongoing Surveys").font(.system(size:15))
                                    Spacer()
                                    Text("10").font(.system(size:15))
                                }
                            }
                        }
                        Section(header:Text("Customer Surveys")){
                            
                            NavigationLink(destination: CompletedSurveysView()) {
                                VStack(alignment:.leading){
                                    Text("My Surveys").font(.system(size:15))
                                }
                            }
                           NavigationLink(destination: OngoingSurveys()) {
                                VStack(alignment:.leading){
                                    Text("Ongoing Surveys").font(.system(size:15))
                                }
                            }
                        }
                        Section(header:Text("Buckup & Sync")){
                            VStack(alignment: .leading, spacing: 4){
                                HStack{
                                    Text("Last Buckup ")
                                    self.getDateView(AppCache.getDate(CacheKeys.LastBuckup))
                                    Spacer()
                                    Button(action: {
                                        // What to perform
                                        self.attemptBuckup()
                                    }) {
                                        //
                                        Text("Buckup Now").font(.system(size:15)).padding(EdgeInsets(top: 4,leading: 4,bottom: 4,trailing: 4))
                                        .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(UIColor.systemFill), lineWidth: 4))
                                    }
                                }
                                HStack{
                                    Text("Last Sync : ").font(.system(size:15))
                                    self.getDateView(AppCache.getDate(CacheKeys.LastSync))
                                    Spacer()
                                    Text("Sync Now").font(.system(size:15)).padding(EdgeInsets(top: 4,leading: 4,bottom: 4,trailing: 4))
                                        .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(UIColor.systemFill), lineWidth: 4)
                                    ).onTapGesture {
                                        self.attemptSync()
                                    }
                                }.padding(.top)
                            }
                        }
                        Section(header:Text("Admin")){
                            NavigationLink(destination: ProfileView()) {
                                VStack(alignment:.leading){
                                    Text("Capture Customer Profile").font(.system(size:15))
                                }
                            }
                            NavigationLink(destination: QuestionsView()) {
                                VStack(alignment:.leading){
                                    Text("Capture Questions").font(.system(size:15))
                                }
                            }
                        }
                    }
                    Spacer()
                    Text("2020 © Croesus App")
                }
                .navigationBarTitle(Text("Overview"))
                .onAppear {
                    //
                }.alert(isPresented: self.$showAlert) { () -> Alert in
                    //
                    if self.action == .SYNC {
                        return Alert(title: Text("SYNC. FAILED"), message: Text("Data sync with backend service has failed.\n\(self.failureMessage)"),
                              primaryButton: .default(Text("TRY-AGAIN"), action: {
                                self.showAlert = false
                                self.attemptSync()
                              }),
                              secondaryButton: .default(Text("Dismiss"), action: {
                                  self.showAlert = false
                              
                                })
                        )
                    }else{
                        
                        return Alert(title: Text("BUCKUP FAILED"), message: Text("Data buckup to backend service has failed.\n\(self.failureMessage)"),
                              primaryButton: .default(Text("TRY-AGAIN"), action: {
                                self.showAlert = false
                                self.attemptBuckup()
                              }),
                              secondaryButton: .default(Text("Dismiss"), action: {
                                  self.showAlert = false
                                })
                        )
                    }
                }
                .actionSheet(isPresented: self.$showSheet) {
                    if self.action == .BUCKUP {
                        return ActionSheet(title: Text("BUCKUP SUCCESS"), message: Text("Data bucked-up successfuly"), buttons: [.default(Text("Dismiss"), action: {
                            self.showSheet = false
                          })])
                        
                    }else{
                        return ActionSheet(title: Text("SYNC SUCCESS"), message: Text("Data Synchronized successfuly"), buttons: [.default(Text("Dismiss"), action: {
                            self.showSheet = false
                          })])
                    }
                }
            }.background(Color.gray)
        }
    }
    
    func attemptSync(){
        //
        action = .SYNC
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
    
    func attemptBuckup(){
        //
        action = .BUCKUP
        showLoading = true
        service.syncData(){status,message in
            //
            if status {
                //
                self.showSheet = true
            }else{
                self.showAlert = true
            }
            self.showLoading = false
        }
    }
    
    func getDateView(_ date:Date?) ->AnyView {
        
        if let date = date {
            return AnyView(Text("\(self.dateFormatter.string(from:  date))").font(.system(size:15)).bold())
        }else{
            return AnyView(Text("Not Available").font(.system(size:15)).bold())
        }
    }
}

@available(iOS 13.0, *)
struct QuickServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            ContentView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        
    }
}

