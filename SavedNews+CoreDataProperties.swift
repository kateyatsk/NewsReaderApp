//
//  SavedNews+CoreDataProperties.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 27.04.25.
//
//

import Foundation
import CoreData


extension SavedNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedNews> {
        return NSFetchRequest<SavedNews>(entityName: "SavedNews")
    }

    @NSManaged public var title: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var source: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?

}

extension SavedNews : Identifiable {

}
