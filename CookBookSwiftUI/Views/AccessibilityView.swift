//
//  AccessibilityView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 13/10/2024.
//

import SwiftUI

struct AccessibilityView: View {
    let pictures = [
        "circle.fill",
        "star.fill",
        "arrow.up",
        "rectangle.fill"
    ]

    let labels = [
        "A circle",
        "A star",
        "An arrow",
        "A rectangle",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)
    @State private var value = 10

    var body: some View {
// #1
        Image(systemName: pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            .foregroundStyle(.green)
            .accessibilityLabel(labels[selectedPicture])
            .accessibilityAddTraits(.isButton)
            .accessibilityRemoveTraits(.isImage)

        Spacer()
// #2
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
//        .accessibilityElement(children: .combine)
// OR
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Your score is 1000")

        Spacer()
// #3
        HStack {
            Button("-") {
                value -= 1
            }

            Text("\(value)")

            Button("+") {
                value += 1
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
                case .increment:
                    value += 1
                case .decrement:
                    value -= 1
                @unknown default:
                    break
            }
        }

        Spacer()
// #4
        Button("John Fitzgerald Kennedy") {
            print("Button tapped")
        }
        .accessibilityInputLabels(["John Fitzgerald Kennedy", "Kennedy", "JFK"])

// #5
        Spacer()

        Image(systemName: "person")
            .accessibilityActions {
                Button("Choose photo") {
                    print("Choose photo")
                }

                Button("Clear") {
                    print("Clear")
                }
            }
    }
}

#Preview {
    AccessibilityView()
}
