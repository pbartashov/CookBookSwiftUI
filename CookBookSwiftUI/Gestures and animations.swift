//
//  Gestures and animations.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 25/9/2024.
//

import SwiftUI

struct Gestures_and_animations: View {

    @State private var dragAmountForImlicitAnimation = CGSize.zero
    @State private var dragAmountForExlicitAnimation = CGSize.zero

    let letters = Array("Hello SwiftUI")
    @State private var lettersEnabled = false
    @State private var dragAmountForLettersAnimation = CGSize.zero

    var body: some View {
        ZStack {
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(.rect(cornerRadius: 10))

            Text("Animates only release")
        }
        .offset(dragAmountForExlicitAnimation)
        .gesture(DragGesture()
            .onChanged {dragAmountForExlicitAnimation = $0.translation }
            .onEnded { _ in
                withAnimation(.bouncy) {
                    dragAmountForExlicitAnimation = .zero
                }
            }
        )

        ZStack {
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(.rect(cornerRadius: 10))

            Text("Animates both drag and release")
        }
        .offset(dragAmountForImlicitAnimation)
        .gesture(DragGesture()
            .onChanged {dragAmountForImlicitAnimation = $0.translation }
            .onEnded { _ in dragAmountForImlicitAnimation = .zero }
        )
        .animation(.bouncy, value: dragAmountForImlicitAnimation)

        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(lettersEnabled ? .blue : .red)
                    .offset(dragAmountForLettersAnimation)
                    .animation(.linear.delay(Double(num) / 20), value: dragAmountForLettersAnimation)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmountForLettersAnimation = $0.translation }
                .onEnded { _ in
                    dragAmountForLettersAnimation = .zero
                    lettersEnabled.toggle()
                }
        )
    }
}

#Preview {
    Gestures_and_animations()
}
