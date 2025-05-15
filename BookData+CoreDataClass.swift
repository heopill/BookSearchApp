//
//  BookData+CoreDataClass.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/14/25.
//
//

import Foundation
import CoreData

@objc(BookData)
public class BookData: NSManagedObject {
    public static let className = "BookData"
    public enum Key {
        static let title = "title"
        static let author = "author"
        static let price = "price"
        static let thumbnail = "thumbnail"
        static let contents = "contents"
        static let isbn = "isbn"
    }
}
