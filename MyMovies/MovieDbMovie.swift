//
//  MovieDbMovie.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/11/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

class MovieDbMovie {

    var backdropURL: String?
    var movieId: NSNumber?
    var overview: String?
    var popularity: Double?
    var posterURL: String?
    var title: String?

//    if let blogs = json["blogs"] as? [[String: AnyObject]] {

    init(dict: NSDictionary) {
        if let backdrop = dict["backdrop_path"] as? String {
            backdropURL = backdrop
        }

        if let d = dict["id"] as? NSNumber {
            movieId = d
        }

        if let o = dict["overview"] as? String {
            overview = o
        }

        if let pop = dict["popularity"] as? Double {
            popularity = pop
        }

        if let poster = dict["poster_path"] as? String {
            posterURL = poster
        }

        if let t = dict["title"] as? String {
            title = t
        }
    }
}