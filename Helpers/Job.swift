//
//  Job.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 6/10/2024.
//

import Foundation
import SwiftData

@Model
class Job {
    var name: String
    var priority: Int
    var owner: SwiftDataUser?

    init(name: String, priority: Int, owner: SwiftDataUser? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
