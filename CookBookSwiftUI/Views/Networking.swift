//
//  Networking.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 2/10/2024.
//

import SwiftUI

// MARK: - AsyncImage

struct AsyncImageView: View {
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)

            AsyncImage(url: URL(string: "badURL")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)
        }
        .padding()
    }
}

#Preview("AsyncImage") {
    AsyncImageView()
}

// MARK: - Receive

struct UserAndFriendsContentView: View {

    @State private var users: [User] = []
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            List(users) {
                Text($0.name)
            }
            .navigationTitle("User&Friends")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    try await fetchUsers()
                } catch {
                    handle(error: error)
                }
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func handle(error: Error) {
        errorTitle = "Error"
        errorMessage = error.localizedDescription
        showingError = true
    }

    private func fetchUsers() async throws {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        users = try decoder.decode([User].self, from: data)
    }
}

#Preview("Receive") {
    UserAndFriendsContentView()
}

// MARK: - Send

struct CheckoutView: View {

    var order: Order

    @State private var alertTitle = ""
    @State private var alertMessge = ""
    @State var showingAlert = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place order"){
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
            .navigationTitle("Check out")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessge)
            }
        }
    }

    private func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decoded = try JSONDecoder().decode(Order.self, from: data)

            alertTitle = "Thank you!"
            alertMessge = "Your order for \(decoded.quantity)x \(Order.types[decoded.type].lowercased()) cupcakes is on its way!"
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
            alertTitle = "Checkout failed"
            alertMessge = "\(error.localizedDescription)\nPlease try again later."
        }

        showingAlert = true
    }
}

#Preview("Send") {
    NavigationStack {
        CheckoutView(order: Order())
    }
}


// MARK: - Data

fileprivate struct User {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
}

extension User: Decodable { }

extension User: Identifiable { }

fileprivate struct Friend {
    let id: String
    let name: String
}

extension Friend: Decodable { }
