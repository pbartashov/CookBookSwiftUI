//
//  Genre.swift
//  Bookworm
//
//  Created by Pavel Bartashov on 3/10/2024.
//

import Foundation

enum Genre: String {
    case fantasy = "Fantasy"
    case horror = "Horror"
    case kids = "Kids"
    case mystery = "Mystery"
    case poetry = "Poetry"
    case romance = "Romance"
}

extension Genre: CaseIterable { }

extension Genre: Codable { }
