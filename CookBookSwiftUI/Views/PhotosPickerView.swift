//
//  PhotosPickerView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 7/10/2024.
//

import PhotosUI
import SwiftUI

struct PhotosPickerView: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImage = [Image]()

    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select a picture", systemImage: "photo")
            }

            ScrollView {
                ForEach(0..<selectedImage.count, id: \.self) { index in
                    selectedImage[index]
                        .resizable()
                        .scaledToFit()
                }
            }

        }
        .onChange(of: pickerItems) {
            Task {
                selectedImage = []
                for item in pickerItems {
                    if let image = try await item.loadTransferable(type: Image.self) {
                        selectedImage.append(image)
                    }
                }
            }
        }
    }
}

#Preview {
    PhotosPickerView()
}
