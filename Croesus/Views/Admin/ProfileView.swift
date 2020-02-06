//
//  ProfileView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    //
    @Environment(\.apiService) var service: ApiService
    
    @ObservedObject var model = ProfileVM()
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var showLoading = false
    @State var showAlert = false
    @State var showSuccess = false
    
    @State var failureMessage = ""
    
    var SuccessSheet: ActionSheet {
        ActionSheet(
            title: Text("Operation Success"),
            message: Text("Profile updated Successfully"),
            buttons: [
                .default(Text("Dismiss"), action: {
                    self.showSuccess = false
                })
            ])

    }
    
    var ImageOptions: ActionSheet {
        ActionSheet(
            title: Text("MODIFY PHOTO"),
            //message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.model.uiImage = nil
                })
            ])

    }
    
    var body: some View {
        GeometryReader { geometry in
            //
            LoadingView(isShowing: self.$showLoading) {
                Form {
                    Section(header: Text("PERSONAL DETAILS").font(.headline)) {
                            
                        HStack(alignment: .bottom, spacing:20){
                            Text("First Name :")
                            TextField("Enter First Name ..",text: self.$model.firstname)}
                        HStack(alignment: .bottom, spacing:20){
                            Text("Last Name :")
                            TextField("Enter Last Name ..", text: self.$model.lastname)}
                        HStack(alignment: .bottom, spacing:20){
                            Text("ID NO. :")
                            TextField("Enter ID No. / Passport No.",text: self.$model.idNo)}
                        if self.isUserInformationValid() {
                            Button(action: {
                                print("Updated profile")
                            }, label: {
                                Text("Update Profile")
                            })
                        }
                    }
                    
                    Section(header: Text("SELFIE").font(.system(.headline))) {
                        if (self.model.uiImage == nil) {
                            Text("Choose a photo:")
                            Image(systemName: "camera.on.rectangle")
                                .accentColor(Color.purple)
                                .background(
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10))
                                .onTapGesture {
                                    self.showImagePicker = true
                            }.padding(.bottom)
                        } else {
                            Text("Your photo:")
                            Image(uiImage: self.model.uiImage!)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.showAction = true
                                }.padding(.bottom)
                        }
                    }
                }.sheet(isPresented: self.$showImagePicker, onDismiss: {
                    self.showImagePicker = false
                }, content: {
                    ImagePicker(isShown: self.$showImagePicker, uiImage: self.$model.uiImage)
                }).actionSheet(isPresented: self.$showAction) {
                    self.ImageOptions
                }.actionSheet(isPresented: self.$showSuccess) {
                    self.SuccessSheet
                }.alert(isPresented: self.$showAlert) { () -> Alert in
                    //
                    return Alert(title: Text("Operation Failed."), message: Text("Profile update failed.\n\(self.failureMessage)"),
                          primaryButton: .default(Text("TRY-AGAIN"), action: {
                            self.showAlert = false
                            self.attemptSave()
                          }),
                          secondaryButton: .default(Text("Dismiss"), action: {
                              self.showAlert = false
                          
                            })
                    )
                }.frame(width: geometry.size.width, height: nil, alignment: .top)
                 .navigationBarTitle(Text("MY PROFILE"))
                 .navigationBarItems(trailing:
                    Button("Save") {
                        self.attemptSave()
                    })
            }
        }
    }
    
    private func isUserInformationValid() -> Bool {
        if model.firstname.isEmpty {
            return false
        }
        
        if model.lastname.isEmpty {
            return false
        }
        return true
    }
    
    func attemptSave(){
        //
        showLoading = true
        service.updateCustomerDetails(model){status,message in
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
