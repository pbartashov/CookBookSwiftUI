//
//  GeometryReaderView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 22/10/2024.
//

import SwiftUI


// MARK: - GeometryReader

struct GeometryReaderView: View {
    var body: some View {
        HStack {
            Text("IMPORTANT")
                .frame(width: 200)
                .background(.blue)

            GeometryReader { proxy in
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width * 0.8)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

#Preview("Geometry reader") {
    GeometryReaderView()
}


// MARK: - Method proxy.frame

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { proxy in
                Text("Center")
                    .background(.blue)
                    .onTapGesture {
                        print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
                        print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
                        print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}

struct GeometryReaderFramesView: View {
    var body: some View {
        OuterView()
            .background(.red)
            .coordinateSpace(name: "Custom")
    }
}

#Preview("GeometryReaderFrames") {
    GeometryReaderFramesView()
}

// MARK: - GeometryReader in ScrollView

struct GeometryReaderInScrollView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("#\(index), y: \(proxy.frame(in: .global).minY, format: .number.notation(.compactName)), hue: \(proxy.frame(in: .global).minY / fullView.size.height, format: .number.notation(.compactName))")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: proxy.frame(in: .global).minY / fullView.size.height, saturation: 1, brightness: 1))
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(proxy.frame(in: .global).minY / 200.0)
                            .scaleEffect(proxy.frame(in: .global).minY / fullView.size.height + 0.5)
                    }
                    .frame(height: 40)
                }
            }
        }

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    GeometryReader { proxy in
                        Text("Number \(num)")
                            .font(.largeTitle)
                            .padding()
                            .background(.red)
                            .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                            .frame(width: 200, height: 200)
                    }
                    .frame(width: 200, height: 200)
                }
            }
        }
    }
}

#Preview("GeometryReader in ScrollView") {
    GeometryReaderInScrollView()
}
