//
//  SignUpView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @State var showWelcomeView: Bool = false
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [ Color.CustomColors.timberwolf, Color.CustomColors.vanilla,]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                
                Spacer()
                
                Image("omg.large.emoji")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                    .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 5)
                
                Text("Shit happens!\nYou're not signed in!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CustomColors.spaceCadet)
                    .shadow(radius: 10)
                
                Text("Click the button below\nto sign in or become a member!")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.CustomColors.spaceCadet)
                    .shadow(radius: 10)
                
                Button {
                    showWelcomeView.toggle()
                } label: {
                    Text("Sign in / Sign up".uppercased())
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.CustomColors.spaceCadet)
                        .cornerRadius(15)
                }
                .tint(Color.CustomColors.vanilla)
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 2)
                Spacer()
            }
            .padding(.all, 40)
            .fullScreenCover(isPresented: $showWelcomeView) {
                WelcomeView()
            }
        .ignoresSafeArea(.all)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
