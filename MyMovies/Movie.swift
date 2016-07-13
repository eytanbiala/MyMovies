//
//  Movie.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/11/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import CoreData


class Movie: NSManagedObject {

    class func entity(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)
    }

    class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "Movie")
    }

    class func fetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController {
        let fr = fetchRequest()
        let desc = NSSortDescriptor(key: "popularity", ascending: false)
        fr.sortDescriptors = [desc]
        let frc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    class func savedFRC(context: NSManagedObjectContext) -> NSFetchedResultsController {
        let fr = fetchRequest()
        fr.predicate = NSPredicate(format: "watchlist != nil", argumentArray: nil)
        let desc = NSSortDescriptor(key: "watchlist.dateSaved", ascending: false)
        fr.sortDescriptors = [desc]
        let frc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    class func movieWithId(movieId: NSNumber, context: NSManagedObjectContext) -> Movie? {
        let fr = fetchRequest()
        fr.predicate = NSPredicate(format: "movieId = %@", movieId)

        var movies = [Movie]()
        do {
            movies = try context.executeFetchRequest(fr) as! [Movie]
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }

        return movies.first
    }

    class func addMovie(model: MovieDbMovie, context: NSManagedObjectContext) -> Movie {
        var movie = movieWithId(model.movieId!, context: context)

        if movie == nil {
            movie = Movie(entity: self.entity(context)!, insertIntoManagedObjectContext: context)
        }

        movie!.backdropPath = model.backdropURL
        movie!.movieId = model.movieId
        movie!.overview = model.overview
        movie!.popularity = model.popularity
        movie!.posterPath = model.posterURL
        movie!.title = model.title

        return movie!
    }

    class func setPoster(movieId: NSNumber, data: NSData, context: NSManagedObjectContext) {
        if let movie = movieWithId(movieId, context: context) {
            movie.poster = data
        }
    }

    class func setBackdrop(movieId: NSNumber, data: NSData, context: NSManagedObjectContext) {
        if let movie = movieWithId(movieId, context: context) {
            movie.backdrop = data
        }
    }

    func posterURL() -> String {
        return "https://image.tmdb.org/t/p/w92\(self.posterPath!)"
    }

    func backdropURL() -> String {
        return "https://image.tmdb.org/t/p/w300\(self.backdropPath!)"
    }

}
