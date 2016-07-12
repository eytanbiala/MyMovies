//
//  ImageLoader.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/10/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

typealias ImageLoadCompletion = (operation: ImageLoadOperation, imageData: NSData?, error: NSError?) -> (Void)

public class ImageLoadOperation : NSOperation {

    public var identifier: String!
    public var imageURL : NSURL!
    var imageLoadCompletion: ImageLoadCompletion! {
        didSet {
            if self.imageLoadCompletion == nil {
                finished = true
                executing = false
            }
        }
    }

    init(id: String, url: NSURL, completion: ImageLoadCompletion) {
        super.init()
        self.name = url.absoluteString
        identifier = id
        imageURL = url
        imageLoadCompletion = completion
    }

    override public var asynchronous: Bool {
        return true
    }

    private var _executing: Bool = false
    override public var executing: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }

    private var _finished: Bool = false;
    override public var finished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValueForKey("isFinished")
                _finished = newValue
                didChangeValueForKey("isFinished")
            }
        }
    }

    override public func main() {
        let request = NSURLRequest(URL:  imageURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in

            guard error == nil && data != nil else {
                print("Error: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageLoadCompletion?(operation: self, imageData: nil, error: error)
                    self.imageLoadCompletion = nil
                })
                return
            }

            dispatch_async(dispatch_get_main_queue(), {
                self.imageLoadCompletion?(operation: self, imageData: data, error: nil)
                self.imageLoadCompletion = nil
            })
        }

        if cancelled {
            self.imageLoadCompletion = nil
            return
        }

        task.resume()
    }
}

class ImageLoader {

    private lazy var queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 10
        queue.name = "ImageLoader"
        queue.qualityOfService = .Utility
        return queue
    }()

    static let sharedInstance = ImageLoader()

    func loadImage(objectId: String, imageURL: String, completion: ImageLoadCompletion) {
        if let url = NSURL(string: imageURL) {
            let operation = ImageLoadOperation(id: objectId, url: url, completion: completion)
            queue.addOperation(operation)
        } else {
            abort()
        }
    }
}