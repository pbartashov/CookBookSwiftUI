//
//  ViewModifiers.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 17/9/2024.
//

import SwiftUI

/// https://www.hackingwithswift.com/books/ios-swiftui/custom-modifiers
/// Tip: Often folks wonder when it’s better to add a custom view modifier versus just adding a new method to View,
/// and really it comes down to one main reason:
/// custom view modifiers can have their own stored properties,
/// whereas extensions to View cannot.


// MARK: - Definition

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

// MARK: - Extension

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

// MARK: - Use (Preview)

struct ViewModifiers: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .titleStyle()
        //            .modifier(Title())
        
        Color.blue
            .frame(width: 300, height: 200)
            .watermarked(with: "Hacking with Swift")
    }
}

#Preview {
    ViewModifiers()
}
