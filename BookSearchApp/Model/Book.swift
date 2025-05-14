//
//  Book.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/13/25.
//

import Foundation

struct BookResponse: Codable {
    let documents: [Book]
}

struct Book: Codable {
    let title: String
    let contents: String
    let authors: [String]
    let price: Int
    let thumbnail: String
}
