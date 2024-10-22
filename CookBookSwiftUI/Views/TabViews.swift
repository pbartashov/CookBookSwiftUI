//
//  TabViews.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/10/2024.
//

import SwiftUI

struct TabViews: View {

    @State private var selectedTab = "One"

    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")

            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}

#Preview {
    TabViews()
}
