//
//  BowTie+CoreDataProperties.swift
//  BowTies
//
//  Created by Stanislav Lemeshaev on 14.01.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import Foundation
import CoreData

extension BowTie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BowTie> {
        return NSFetchRequest<BowTie>(entityName: "BowTie")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastWorn: Date?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var searchKey: String?
    @NSManaged public var timesWorn: Int32
    @NSManaged public var url: URL?
    @NSManaged public var tintColor: NSObject?

}

extension BowTie: Identifiable {
    // 
}
