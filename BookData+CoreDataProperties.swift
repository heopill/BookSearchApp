//
//  BookData+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/14/25.
//
//

import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var title: String?
    @NSManaged public var contents: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var price: Int32
    @NSManaged public var author: String?
    @NSManaged public var isbn: String?
    
}

extension BookData : Identifiable {

}
