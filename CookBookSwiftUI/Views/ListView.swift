//
//  ListView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/10/2024.
//

import SwiftUI

struct ListView: View {

    @State private var users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selection = Set<String>()

    var body: some View {
        List(selection: $selection) {
            ForEach(users, id: \.self) { user in
                Text(user)
                    .swipeActions {
                        Button("Send message", systemImage: "message") {
                            print("Hi")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button("Pin", systemImage: "pin") {
                            print("Pinning")
                        }
                        .tint(.orange)
                    }
            }
            .onDelete { indexSet in
                users.remove(atOffsets: indexSet)
            }

            Text("More")
                .swipeActions {
                    Button("Send message", systemImage: "star") {
                        print("Hi")
                    }
                }
        }
        .toolbar {
            EditButton()
        }

        if selection.isEmpty == false {
            Text("You selected \(selection.formatted())")
        }
    }
}

#Preview {
    NavigationStack {
        ListView()
    }
}
