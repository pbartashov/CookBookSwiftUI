//
//  Buttons.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 13/10/2024.
//

import SwiftUI

struct Buttons: View {
    var body: some View {
        Button {
            // action
        } label: {
            Image(systemName: "circle")
                .resizable()
                .scaledToFit()
        }
        .accessibilityLabel("Action")
    }
}

#Preview {
    Buttons()
}
