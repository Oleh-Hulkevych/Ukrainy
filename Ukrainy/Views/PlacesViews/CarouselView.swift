//
//  CarouselView.swift
//  Ukrainy
//
//  Created by Hulkevych on 13.11.2022.
//

import SwiftUI

struct CarouselView: View {
    
    @State var selection: Int = 1
    
    let maxCount: Int = 5
    
    @State var timerAdded: Bool = false
    
    var body: some View {
        TabView(selection: $selection, content: {
            ForEach(1..<maxCount) { count in
                Image("Ukrainе00\(count)")
                    .resizable()
                    .scaledToFill()
                    .tag(count)
            }
        })
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default, value: true)
        .onAppear {
            if !timerAdded {
                addTimer()
            }
        }
    }
    
    func addTimer() {
        timerAdded = true
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { ( timer ) in
            
            if selection == maxCount - 1 {
                selection = 1
            } else {
                selection += 1
            }
        }
        timer.fire()
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
