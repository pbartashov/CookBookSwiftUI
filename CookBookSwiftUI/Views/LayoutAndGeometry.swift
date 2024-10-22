//
//  LayoutAndGeometry.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 21/10/2024.
//

import SwiftUI

struct LayoutAndGeometry: View {
    var body: some View {
        // #1
        VStack(alignment: .leading) {
            Text("Hello, world!")
                .alignmentGuide(.leading) { d in d[.trailing] }
            Text("This is a longer line of text ")
        }
        .background(.red)
        .frame(width: 400, height: 400)
        .background(.blue)

        // #2
        VStack(alignment: .leading) {
            ForEach(0..<10) { position in
                Text("Number \(position)")
                    .alignmentGuide(.leading) { _ in Double(position) * -10 }
            }
        }
        .background(.red)
        .frame(width: 400, height: 400)
        .background(.blue)
    }
}

#Preview {
    LayoutAndGeometry()
}


// MARK: - Custom alignment guide

struct CustomAlignmentGuideLayoutAndGeometry: View {
    var body: some View {
       HStack(alignment: .midAccountName) {
            VStack {
                Text("1")
                    .foregroundStyle(.secondary)
                Text("@twostraws")
                    .alignmentGuide(.midAccountName) { d in
                        d[VerticalAlignment.center]
                    }
                Image(.twinlake)
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack {
                Text("2")
                    .foregroundStyle(.secondary)
                Text("Full name:")
                Text("PAUL HUDSON")
                    .alignmentGuide(.midAccountName) { d in
                        d[VerticalAlignment.center]
                    }
                    .font(.largeTitle)
            }
        }
    }
}

#Preview("Custom alignment guide") {
    CustomAlignmentGuideLayoutAndGeometry()
}

extension VerticalAlignment {
    enum MidAccountName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }

    static var midAccountName = VerticalAlignment(MidAccountName.self)
}


// MARK: - Absolute positioning

struct AbsolutePositioningView: View {
    var body: some View {
        ZStack {
            Text("Hello, world!")
                .background(.red)
                .position(x: 100, y: 100)

            Text("Center")

            Text("Hello, world!")
                .background(.green)
                .offset(x: 100, y: 100)
        }
    }
}

#Preview("Absolute positioning view") {
    AbsolutePositioningView()
}

// MARK: - Method visualEffect


struct VisualEffectView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    Text("Number \(num)")
                        .font(.largeTitle)
                        .padding()
                        .background(.red)
                        .frame(width: 200, height: 200)
                        .visualEffect { content, proxy in
                            content
                                .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview("VisualEffectView") {
    VisualEffectView()
}
