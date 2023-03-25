//
//  SettingsEditImageView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct SettingsEditImageView: View {
    
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage
    @Binding var profileImage: UIImage
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    @State var showImagePicker: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @State var showSuccessAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 25) {
                
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipped()
                    .cornerRadius(100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.CustomColors.spaceCadet, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                
                HStack(alignment: .center) {
                    
                    Text(description)
                        .multilineTextAlignment(.center)
                        .tint(Color.CustomColors.spaceCadet)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                
                Button {
                    showImagePicker.toggle()
                } label: {
                    HStack {
                        Image(systemName: "photo.fill")
                            .font(.title)
                        Text("Import")
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.CustomColors.spaceCadet)
                    .cornerRadius(15)
                    .font(.system(size: 23, weight: .semibold, design: .default))
                }
                .tint(Color.CustomColors.vanilla)
                .shadow(color: .black.opacity(0.75), radius: 10, x: 0, y: 2)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                }
                
                Button {
                    saveImage()
                } label: {
                    HStack(spacing: 12) {
                        Image("save.custom")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                        Text("Save")
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.CustomColors.spaceCadet)
                    .cornerRadius(15)
                    .font(.system(size: 23, weight: .semibold, design: .default))
                }
                .tint(Color.CustomColors.vanilla)
                .shadow(color: .black.opacity(0.75), radius: 10, x: 0, y: 2)

                Spacer()
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showSuccessAlert) {
                return Alert(title: Text("Success!"), message: nil, dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }
    }
    
    // MARK: - Methods
    
    func saveImage() {
        
        guard let userID = currentUserID else { return }
        
        // Update the UI of the profile
        self.profileImage = selectedImage
        
        // Update profile image in database
        ImageManager.instance.uploadProfileImage(userID: userID, image: selectedImage)
        
        self.showSuccessAlert.toggle()
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(named: "user.large.emoji.black")!
    @State static var description: String = "Your profule picture.\nIt will be seen by the other users in your profile.\nAlso it will be displayed in your posts."
    
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(title: "Title", description: description, selectedImage: image, profileImage: $image)
        }
    }
}
