//
//  FaceID.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 11/10/2024.
//

import LocalAuthentication
import SwiftUI

///https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui
///Select your current target, go to the Info tab, right-click on an existing key, then choose Add Row. Scroll through the list of keys until you find “Privacy - Face ID Usage Description” and give it the value “We need to unlock your data.”

struct FaceID: View {

    @State private var isUnlocked = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }

            Button("Unlock", action: authenticate)

            if let errorMessage {
                Text(errorMessage)
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            // Remember, the string in our code is used for Touch ID,
            // whereas the string in Info.plist is used for Face ID.
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    isUnlocked = true
                } else {
                    // there was a problem
                    errorMessage = authenticationError?.localizedDescription
                }
            }
        } else {
            // no biometrics
            errorMessage = error?.localizedDescription
        }
    }
}

#Preview {
    FaceID()
}
