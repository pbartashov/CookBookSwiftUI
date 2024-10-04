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
