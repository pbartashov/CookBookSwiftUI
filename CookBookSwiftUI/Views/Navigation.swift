//
//  Navigation.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 1/10/2024.
//

import SwiftUI

struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct NavigationView: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}

#Preview {
    NavigationView()
}

// MARK: - NavigationBar

struct NavigationBar: View {
    @State private var title = "SwiftUI"

    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Row \(i)") {
                    Text("Row \(i)")
                        .navigationBarBackButtonHidden()

                }
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)

            .toolbarBackground(.blue)
            .toolbarColorScheme(.dark)
            //            .toolbar(.hidden, for: .navigationBar)

            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Tap Me") {
                        // button action here
                    }

                    Button("Or Tap Me") {
                        // button action here
                    }
                }
            }

        }
    }
}

#Preview("NavigationBar") {
    NavigationBar()
}

// MARK: - PathStore

@Observable
final class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        guard
            let data = try? Data(contentsOf: savePath),
            let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data)
        else {
            path = NavigationPath()
            return
        }


        path = NavigationPath(decoded)
    }

    private func save() {
        do {
            guard let representation = path.codable else {
                throw PathstoreError.codableError
            }

            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Fail to save navigation data")
        }
    }

    enum PathstoreError: Error {
        case codableError
    }
}
