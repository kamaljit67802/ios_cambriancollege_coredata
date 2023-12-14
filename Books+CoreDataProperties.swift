//
//  Books+CoreDataProperties.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-09.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var publicationyear: String?
    @NSManaged public var synopsis: String?
    @NSManaged public var booksToAuthor: Author?

}

extension Books : Identifiable {

}
