//
//  Author+CoreDataProperties.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-09.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var id: String?
    @NSManaged public var fname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var authorToBooks: Set<Books>?

}

// MARK: Generated accessors for authorToBooks
extension Author {

    @objc(addAuthorToBooksObject:)
    @NSManaged public func addToAuthorToBooks(_ value: Books)

    @objc(removeAuthorToBooksObject:)
    @NSManaged public func removeFromAuthorToBooks(_ value: Books)

    @objc(addAuthorToBooks:)
    @NSManaged public func addToAuthorToBooks(_ values: Set<Books>)

    @objc(removeAuthorToBooks:)
    @NSManaged public func removeFromAuthorToBooks(_ values: Set<Books>)

}

extension Author : Identifiable {

}
