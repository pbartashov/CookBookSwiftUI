//
//  CoreImageView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 7/10/2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct CoreImageView: View {

    @State private var image: Image?
    @State private var multiplyer1 = 0.5
    @State private var multiplyer2 = 0.5

    private var amount: Double {
        multiplyer1 * multiplyer2
    }

    var body: some View {
        VStack {
            VStack {
                Slider(value: $multiplyer1, in: 0...1, step: 0.1)

                Slider(value: $multiplyer2, in: 0...100, step: 1)

                Text("Amount \(amount)")
            }


            image?
                .resizable()
                .scaledToFit()

            ContentUnavailableView {
                Label("No snippets", systemImage: "swift")
            } description: {
                Text("You don't have any saved snippets yet.")
            } actions: {
                Button("Create Snippet") {
                    // create a snippet
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear(perform: loadImage)
        .onChange(of: amount) {
            loadImage()
        }
    }

    func loadImage() {
        let inputImage = UIImage(resource: .twinlake)
        let beginImage = CIImage(image: inputImage)

        let context = CIContext()

        //        let currentFilter = CIFilter.sepiaTone()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.intensity = 1

        //        let currentFilter = CIFilter.pixellate()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.scale = 100

        //        let currentFilter = CIFilter.crystallize()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.radius = 10

        //        let currentFilter = CIFilter.twirlDistortion()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.radius = 1000
        //        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)

        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    CoreImageView()
}
