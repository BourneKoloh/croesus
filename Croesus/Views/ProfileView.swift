//
//  ProfileView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct Location {
    static let allLocations = [
        "New York",
        "London",
        "Tokyo",
        "Berlin",
        "Paris"
    ]
}

struct ProfileView: View {
    
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var location = ""
    @State private var idNo = ""
    @State private var termsAccepted = false
    @State private var age = 20
    
    private let oldPasswordToConfirmAgainst = "12345"
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmedPassword = ""
    
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var uiImage: UIImage? = nil
    
    var sheet: ActionSheet {
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
                    self.uiImage = nil
                })
            ])

    }
    
    var body: some View {
        GeometryReader { geometry in
            //
            Form {
                Section(header: Text("PERSONAL DETAILS").font(.headline)) {
                        
                    HStack(alignment: .bottom, spacing:20){
                        Text("First Name :")
                        TextField("Enter First Name ..",text: self.$firstname)}
                    HStack(alignment: .bottom, spacing:20){
                        Text("Last Name :")
                        TextField("Enter Last Name ..", text: self.$lastname)}
                    HStack(alignment: .bottom, spacing:20){
                        Text("ID NO. :")
                        TextField("Enter ID No. / Passport No.",text: self.$idNo)}
                    if self.isUserInformationValid() {
                        Button(action: {
                            print("Updated profile")
                        }, label: {
                            Text("Update Profile")
                        })
                    }
                }
                
                Section(header: Text("SELFIE").font(.system(.headline))) {
                    if (self.uiImage == nil) {
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
                        Image(uiImage: self.imageOrientation(self.uiImage!))
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
                ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
            }).actionSheet(isPresented: self.$showAction) {
                self.sheet
            }.frame(width: geometry.size.width, height: nil, alignment: .top)
             .navigationBarTitle(Text("MY PROFILE"))
             .navigationBarItems(trailing:
                Button("Save") {
                    print("Save tapped!")
                })
        }
    }
    
    private func isUserInformationValid() -> Bool {
        if firstname.isEmpty {
            return false
        }
        
        if lastname.isEmpty {
            return false
        }
        
        if !termsAccepted {
            return false
        }
        
        if location.isEmpty {
            return false
        }
        
        return true
    }
    
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        @unknown default:
            break
        }

        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        @unknown default:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }

        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)

        return img
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
