//
//  SettingsLabelView.swift
//  Ukrainy
//
//  Created by Hulkevych on 14.11.2022.
//

import SwiftUI

struct SettingsLabelView: View {
    
    var labelText: String
    var labelImage: String
    
    var body: some View {
        
        VStack {
            HStack {
                Text(labelText)
                    .fontWeight(.bold)
                
                Spacer()
                Image(systemName: labelImage)
            }
            
            Divider()
                .padding(.vertical, 5)
        }
    }
}

struct SettingsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabelView(labelText: "Text Label", labelImage: "heart")
            .previewLayout(.sizeThatFits)
    }
}
