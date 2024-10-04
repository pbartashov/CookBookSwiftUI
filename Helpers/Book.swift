//
//  Book.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 4/10/2024.
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var genre: Genre
    var review: String
    var rating: Int
    var date: Date

    init(title: String, author: String, genre: Genre, review: String, rating: Int, date: Date) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}
