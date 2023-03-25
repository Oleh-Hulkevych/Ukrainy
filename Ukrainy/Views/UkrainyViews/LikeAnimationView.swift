//
//  LikeAnimationView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct LikeAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        
        ZStack {
            
            Image(systemName: "heart.fill")
                .foregroundColor(Color.red.opacity(0.3))
                .font(.system(size: 200))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.3)
            
            Image(systemName: "heart.fill")
                .foregroundColor(Color.red.opacity(0.6))
                .font(.system(size: 150))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.5)
            
            Image(systemName: "heart.fill")
                .foregroundColor(Color.red.opacity(0.9))
                .font(.system(size: 100))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.7)
        }
        .animation(Animation.easeOut(duration: 0.5), value: animate)
    }
}

struct LikeAnimationView_Previews: PreviewProvider {
    
    @State static var animate: Bool = false
    
    static var previews: some View {
        LikeAnimationView(animate: $animate)
            .previewLayout(.sizeThatFits)
    }
}
