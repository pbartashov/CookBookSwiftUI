//
//  Texts.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/9/2024.
//

import SwiftUI

struct Texts: View {

    let count = 5

    @FocusState private var isFocused
    @State private var text = ""

    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle.weight(.semibold))
                //            .font(.largeTitle.bold())
                    .foregroundColor(.green)
                    .foregroundStyle(.secondary)
                    .padding()

                    .background(.ultraThinMaterial)
                    .padding()

                Text(String(count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)

                TextField("Text", text: $text)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
            }
        }
    }
}

#Preview {
    Texts()
}
