//
//  PostImageView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var captionText: String = ""
    @Binding var imageSelected: UIImage
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    @State var showAlert: Bool = false
    @State var postUploadedSuccessfully: Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                ZStack {
                    
                    VStack(spacing: 20) {
                        
                        Image(uiImage: imageSelected)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(alignment: .center)
                            .cornerRadius(15)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 2.5)
                            )
                            .shadow(radius: 15)
                        
                        TextField("Add description here...", text: $captionText)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .light ? Color.CustomColors.timberwolf : Color.CustomColors.spaceCadet)
                            .cornerRadius(15)
                            .font(.headline)
                            .autocapitalization(.sentences)
                            .shadow(radius: 15)
                        
                        Button {
                            postPicture()
                        } label: {
                            HStack {
                                Image(systemName: "photo")
                                Text("Post picture")
                            }
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.CustomColors.vanilla)
                            .foregroundColor(Color.CustomColors.vanDyke)
                            .cornerRadius(15)
                            .font(.system(size: 23, weight: .semibold, design: .default))
                            .shadow(radius: 15)
                        }
                        .tint(Color.CustomColors.timberwolf)
                        
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Cancel")
                                }
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(Color.CustomColors.vanilla)
                                .foregroundColor(Color.CustomColors.vanDyke)
                                .cornerRadius(15)
                                .font(.system(size: 23, weight: .semibold, design: .default))
                                .shadow(radius: 15)
                            }
                            .tint(Color.CustomColors.timberwolf)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.CustomColors.vanDyke)
            .alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
            }
        }
    }
    
    // MARK: Methods
    
    func postPicture() {
        print("POST PICTURE TO DATABASE HERE")
        
        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
            print("Error getting userID or displayname while posting image")
            return
        }
        
        DataService.instance.uploadPost(image: imageSelected, caption: captionText, displayName: displayName, userID: userID) { (success) in
            self.postUploadedSuccessfully = success
            self.showAlert.toggle()
        }
    }
    
    func getAlert() -> Alert {
        
        if postUploadedSuccessfully {
            return Alert(title: Text("Successfully uploaded post! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else {
            return Alert(title: Text("Error uploading post 😭"))
        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "Ukrainе006")!
    
    static var previews: some View {
        PostImageView(imageSelected: $image)
            .preferredColorScheme(.light)
    }
}
