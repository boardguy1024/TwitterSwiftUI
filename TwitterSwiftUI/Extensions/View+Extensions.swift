//
//  View+Extensions.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/08.
//

import SwiftUI

extension View {
    
    var xLogoSmall: some View {
        Image("xlogo")
            .resizable()
            .scaledToFit()
            .frame(width: 26, height: 26)
    }
          
    var xLogo: some View {
        Image("xlogo")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
    }
}
