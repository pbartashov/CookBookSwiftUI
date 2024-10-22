//
//  SwiftDataUser.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 6/10/2024.
//

import Foundation
import SwiftData

@Model
class SwiftDataUser {
    var name: String
    var city: String
    var joinDate: Date

    @Relationship(deleteRule: .cascade) var jobs = [Job]()

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
