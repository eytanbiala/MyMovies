//
//  Watchlist+CoreDataProperties.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Watchlist {

    @NSManaged var dateSaved: NSDate?
    @NSManaged var seen: NSNumber?
    @NSManaged var movie: Movie?

}
