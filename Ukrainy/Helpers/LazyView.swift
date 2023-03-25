//
//  LazyView.swift
//  Ukrainy
//
//  Created by Hulkevych on 18.11.2022.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
