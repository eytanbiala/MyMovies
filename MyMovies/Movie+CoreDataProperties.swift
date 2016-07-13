//
//  Movie+CoreDataProperties.swift
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

extension Movie {

    @NSManaged var backdrop: NSData?
    @NSManaged var movieId: NSNumber?
    @NSManaged var popularity: NSNumber?
    @NSManaged var title: String?
    @NSManaged var overview: String?
    @NSManaged var poster: NSData?
    @NSManaged var posterPath: String?
    @NSManaged var backdropPath: String?
    @NSManaged var watchlist: Watchlist?

}
