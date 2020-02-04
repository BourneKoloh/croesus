//
//  ContentView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let services:[AppService] = AppUtils.getServices()
    
    init(){
        //
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
        //
        //UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        //
        //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        //
        NavigationView {
            //
            VStack{
                List {
                    Section(header:Text("Services")){
                        NavigationLink(destination: SummaryView()) {
                            VStack(alignment:.leading){
                                Text("Summary").font(.title)
                                Text("An overview of your recent activities").padding(.leading)
                            }
                        }
                        NavigationLink(destination: QuestionsView()) {
                            VStack(alignment:.leading){
                                Text("Surveys").font(.title)
                                Text("View our open surveys").padding(.leading)
                            }
                        }
                        NavigationLink(destination: ProfileView()) {
                            VStack(alignment:.leading){
                                Text("My Profile").font(.title)
                                Text("View and update your profile details").padding(.leading)
                            }
                        }
                    }
                }
                Spacer()
                Text("2020 © Croesus App")
            }
            .navigationBarTitle(Text("Overview"))
        }.background(Color.gray)
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

