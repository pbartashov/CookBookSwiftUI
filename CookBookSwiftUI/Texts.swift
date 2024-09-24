//
//  Texts.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/9/2024.
//

import SwiftUI

struct Texts: View {
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()

            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.largeTitle.weight(.semibold))
            //            .font(.largeTitle.bold())
                .foregroundColor(.green)
                .foregroundStyle(.secondary)
                .padding()

               .background(.ultraThinMaterial)
               .padding()
        }
    }
}

#Preview {
    Texts()
}
