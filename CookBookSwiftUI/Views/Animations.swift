//
//  Animations.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 25/9/2024.
//

import SwiftUI

struct Animations: View {

    @State private var explicitAnimationAmount = 1.0
    @State private var implicitAnimationAmount = 1.0
    @State private var bindingAnimationAmount = 1.0

    @State private var enabled = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // MARK: - Animating views (explicit)
                // https://www.hackingwithswift.com/books/ios-swiftui/creating-explicit-animations
                HStack {
                    Text("Explicit").font(.title)

                    Button("Tap Me") {
                        withAnimation(.spring(duration: 1, bounce: 0.8)) {
                            explicitAnimationAmount += 360
                        }
                    }
                    .padding(50)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(.circle)
                    .rotation3DEffect(.degrees(explicitAnimationAmount), axis: (x: 0, y: 1, z: 0))
                }

                Spacer()

                // MARK: - Animating views (implicit)
                // https://www.hackingwithswift.com/books/ios-swiftui/customizing-animations-in-swiftui
                HStack {
                    Text("Implicit").font(.title)
                    Button("Tap Me") {
                        // animationAmount += 1
                    }
                    .padding(50)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(.circle)
                    .overlay(
                        Circle()
                            .stroke(.red)
                            .scaleEffect(implicitAnimationAmount)
                            .opacity(2 - implicitAnimationAmount)
                            .animation(
                                .easeInOut(duration: 1)
                                .repeatForever(autoreverses: false),
                                value: implicitAnimationAmount
                            )
                    )
                    .onAppear {
                        implicitAnimationAmount = 2
                    }
                }

                Spacer()

                // MARK: - Animating value bindings
                // https://www.hackingwithswift.com/books/ios-swiftui/animating-bindings

                VStack(spacing: 50) {
                    Stepper("Scale amount",
                            value: $bindingAnimationAmount.animation(
                                .easeInOut(duration: 1)
                                .repeatCount(3, autoreverses: true)
                            ),
                            in: 1...10
                    )

                    HStack {
                        Text("Binding").font(.title)
                        Button("Tap Me") {
                            bindingAnimationAmount += 1
                        }
                        .padding(40)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(.circle)
                        .scaleEffect(bindingAnimationAmount)
                    }
                }

                Spacer()

                // MARK: - Animating value bindings
                // https://www.hackingwithswift.com/books/ios-swiftui/controlling-the-animation-stack

                HStack {
                    Text("Animation stack").font(.title)
                    Button("Tap Me") {
                        enabled.toggle()
                    }
                    .frame(width: 200, height: 200)
                    .background(enabled ? .blue : .red)
                    //        .animation(nil, value: enabled)
                    .animation(.default, value: enabled)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
                    .animation(.spring(duration: 1, bounce: 0.6), value: enabled)
                }
            }
            .padding()
            .toolbar {
                Button("Reset", action: reset)
            }
        }
    }

    private func reset() {
        bindingAnimationAmount = 1.0
        explicitAnimationAmount = 1.0
        implicitAnimationAmount = 1.0
    }
}

struct Transitions: View {

    @State private var isShowingRed = false
    @State private var isShowingRedForViewModifier = false

    var body: some View {

        // MARK: - Transition
        // https://www.hackingwithswift.com/books/ios-swiftui/showing-and-hiding-views-with-transitions
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }

            Spacer()

            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 200, height: 200)

                if isShowingRedForViewModifier {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 200, height: 200)
                        .transition(.pivot)
                }

                Text("And me")
            }
            .onTapGesture {
                withAnimation {
                    isShowingRedForViewModifier.toggle()
                }
            }
        }
    }
}

// MARK: - ViewModifier
// https://www.hackingwithswift.com/books/ios-swiftui/building-custom-transitions-using-viewmodifier
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

// MARK: - Extension
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topTrailing)
        )
    }
}

#Preview("Animations") {
    Animations()
}

#Preview("Transitions") {
    Transitions()
}
