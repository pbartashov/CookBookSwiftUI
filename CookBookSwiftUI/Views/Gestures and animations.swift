//
//  Gestures and animations.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 25/9/2024.
//

import SwiftUI

/// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui

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

// MARK: - onLongPressGesture

struct OnLongPressGestureGestures: View {
    var body: some View {
        Text("Tap me long enough to see the print!")
            .onLongPressGesture(minimumDuration: 1) {
                print("Long pressed!")
            } onPressingChanged: { inProgress in
                print("In progress: \(inProgress)!")
            }
    }
}

#Preview("onLongPressGesture") {
    OnLongPressGestureGestures()
}


// MARK: - MagnifyGesture

struct MagnifyGestureView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0

    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification - 1
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}

#Preview("MagnifyGesture") {
    MagnifyGestureView()
}

// MARK: - RotateGesture

struct RotateGestureView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero

    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        currentAmount = value.rotation
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = .zero
                    }
            )
    }
}

#Preview("RotateGesture") {
    RotateGestureView()
}

// MARK: - highPriorityGesture

struct HighPriorityGestureContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded {
                    print("VStack tapped")
                }
        )
    }
}

#Preview("highPriorityGesture") {
    HighPriorityGestureContentView()
}

// MARK: - Gesture sequences

struct GestureSequencesView: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Circle tapped!")
                }
        }
    }
}

#Preview("Gesture sequences") {
    GestureSequencesView()
}


