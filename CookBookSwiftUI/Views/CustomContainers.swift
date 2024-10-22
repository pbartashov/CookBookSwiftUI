//
//  CustomContainers.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 17/9/2024.
//

import SwiftUI


///https://www.hackingwithswift.com/books/ios-swiftui/custom-containers

// MARK: - Definition

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

struct CustomContainers: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            VStack {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
            .padding()
        }
    }
}

#Preview {
    CustomContainers()
}
