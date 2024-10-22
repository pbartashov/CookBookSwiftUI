//
//  TestView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 14/10/2024.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        DetailedTestView()
            .environment(\.userRole, DebugUserRole.adminDebug)
    }
}

struct DetailedTestView: View {
    @Environment(\.userRole) var userRole
    var body: some View {
        Text("Hello, World!")
        Text(userRole.title)
     }
}

#Preview {
    TestView()
}

protocol UserRoles {
    var title: String { get }
}

enum UserRole: UserRoles {
    case admin, regular, guest
    var title: String {
        "UserRole"
    }
}

enum DebugUserRole: UserRoles {
    case adminDebug, regularDebug, guestDebug
    var title: String {
        "DebugUserRole"
    }
}

extension EnvironmentValues {
    @Entry var userRole: UserRoles = UserRole.guest
}
