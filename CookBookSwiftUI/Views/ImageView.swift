//
//  ImageView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/10/2024.
//

import SwiftUI

struct ImageView: View {
    var body: some View {
        Image(.example)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .background(.black)
    }
}

#Preview {
    ImageView()
}
