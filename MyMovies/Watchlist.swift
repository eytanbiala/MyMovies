//
//  Watchlist.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/11/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import CoreData


class Watchlist: NSManagedObject {

    class func entity(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName("Watchlist", inManagedObjectContext: context)
    }

    class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "Watchlist")
    }

    class func fetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController {
        let fr = fetchRequest()
        let desc = NSSortDescriptor(key: "dateSaved", ascending: false)
        fr.sortDescriptors = [desc]
        let frc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    class func saveMovie(movie: Movie) -> Watchlist {
        var watchlist = movie.watchlist

        if watchlist == nil {
            watchlist = Watchlist(entity: self.entity(movie.managedObjectContext!)!, insertIntoManagedObjectContext: movie.managedObjectContext)
            movie.watchlist = watchlist
        }

        watchlist?.dateSaved = NSDate()
        watchlist?.seen = NSNumber(bool: false)

        return watchlist!
    }

    class func removeMovie(movie: Movie) {
        if let w = movie.watchlist {
            movie.watchlist = nil
            movie.managedObjectContext?.deleteObject(w)
        }
    }

}
