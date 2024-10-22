//
//  Gradients.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/9/2024.
//

import SwiftUI

struct Gradients: View {
    var body: some View {
        RadialGradient(
            stops: [
                .init(
                    color: Color(
                        red: 0.1, green: 0.2, blue: 0.45
                    ),
                    location: 0.3
                ),
                .init(
                    color: Color(
                        red: 0.76, green: 0.15, blue: 0.26
                    ),
                    location: 0.3
                ),
            ],
            center: .top,
            startRadius: 200,
            endRadius: 400
        ).ignoresSafeArea()
    }
}

#Preview {
    Gradients()
}
