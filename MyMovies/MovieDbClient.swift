//
//  MovieDbClient.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/5/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

typealias MovieDbClientResult = (error: NSError?, result: Dictionary<String, AnyObject>?) -> (Void)

let BaseURL = "https://api.themoviedb.org/3/"
let ImageBaseURL = "https://image.tmdb.org/t/p/"
let ImageSize = "w300"
//https://api.themoviedb.org/3/configuration?api_key=97964bf71f0eafa9dac1e42b1d4d9a52
let ApiKey = "97964bf71f0eafa9dac1e42b1d4d9a52"
//movie/550?api_key=97964bf71f0eafa9dac1e42b1d4d9a52

class MovieDbClient {

    private class func jsonFromResponseData(data: NSData) -> Dictionary<String, AnyObject>? {
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            return jsonObject as? Dictionary<String, AnyObject>
        } catch let jsonError as NSError {
            print(jsonError.localizedDescription)
        }

        return nil
    }

    private class func movieDbTaskWithCompletion(request: NSURLRequest, completion: MovieDbClientResult?) {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            guard error == nil && data != nil else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(error: error, result: nil)
                })
                return
            }

            let json = jsonFromResponseData(data!)
            //print(json)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(error: error, result: json)
            })
        }
        task.resume()
    }

    class func abc(completion: MovieDbClientResult?) {
        let url = NSURL(string: "")
        let request = NSURLRequest(URL: url!)
        movieDbTaskWithCompletion(request, completion: completion)
    }
}