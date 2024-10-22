//
//  UserNotificationView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 16/10/2024.
//

import SwiftUI
import UserNotifications

struct UserNotificationView: View {

    @State private var statusText = ""

    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        statusText = "All set!"
                    } else if let error {
                        statusText = error.localizedDescription
                    }
                }
            }

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default

                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }

            Spacer()

            Text(statusText)
        }
    }
}

#Preview {
    UserNotificationView()
}
