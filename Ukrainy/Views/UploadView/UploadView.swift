//
//  UploadView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI
import UIKit

struct UploadView: View {
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var showPostImageView: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                
                Image("heart.large.emoji")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300, alignment: .center)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 5)
                    .fullScreenCover(isPresented: $showPostImageView, content: {
                        PostImageView(imageSelected: $imageSelected)
                            .preferredColorScheme(colorScheme)
                    })
                
                ZStack {
                    
                    VStack(spacing: 20) {
                        
                        Text("Let's make a new post!")
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.CustomColors.vanilla)
                            .shadow(radius: 5)
                            .opacity(0.75)
                        
                        Button {
                            sourceType = UIImagePickerController.SourceType.camera
                            showImagePicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Take photo")
                            }
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.CustomColors.vanilla)
                            .foregroundColor(Color.CustomColors.vanDyke)
                            .cornerRadius(15)
                            .font(.system(size: 25, weight: .semibold, design: .default))
                            .shadow(radius: 15)
                        }
                        
                        Button {
                            sourceType = UIImagePickerController.SourceType.photoLibrary
                            showImagePicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Import photo")
                            }
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.CustomColors.vanilla)
                            .foregroundColor(Color.CustomColors.vanDyke)
                            .cornerRadius(15)
                            .font(.system(size: 25, weight: .semibold, design: .default))
                            .shadow(radius: 15)
                        }
                    }
                }
                .padding(.all)
                .background(Color.CustomColors.vanDyke)
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 5)
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $showImagePicker, onDismiss: segueToPostImageView, content: {
                ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? Color.CustomColors.spaceCadet : Color.CustomColors.gold)
            })
        }
    }
    
    func segueToPostImageView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPostImageView.toggle()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            .preferredColorScheme(.dark)
    }
}
