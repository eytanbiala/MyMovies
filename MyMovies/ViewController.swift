//
//  ViewController.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/5/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var refreshControl:  UIRefreshControl?

    var _fetchedResultsController: NSFetchedResultsController?

    var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController == nil {
                _fetchedResultsController = getFetchedResultsController()
            }
            return _fetchedResultsController!
        }
    }

    func getFetchedResultsController() -> NSFetchedResultsController {
        let frc = Movie.fetchedResultsController(CoreDataStack.sharedInstance.context)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let fetchError as NSError {
            print(fetchError)
        }

        return frc
    }

    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 64
        table.registerNib(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "Movie")
        return table
    }()

    private var loadingIndicator: UIActivityIndicatorView?


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Popular"

        table.frame = view.bounds
        view.addSubview(table);

        setupRefresh()
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let path = table.indexPathForSelectedRow {
            table.deselectRowAtIndexPath(path, animated: animated)
        }
    }

    func setupRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refreshControl!)
    }

    func loadData() {
        refreshControl?.endRefreshing()

        showLoadingIndicator()

        MovieDbClient.getPopularMovies { (error, result) -> (Void) in

            self.hideLoadingIndicator()

            guard error == nil else {
                return
            }

            if let movies = result?["results"] as? [[String: AnyObject]] {
                for movie in movies {
                    let model = MovieDbMovie(dict: movie)
                    print("Adding movie: \(model.title)")
                    let db = Movie.addMovie(model, context: CoreDataStack.sharedInstance.context)
                    self.loadImagesForMovie(db)
                }
                CoreDataStack.sharedInstance.save()
            }
        }
    }

    func loadImagesForMovie(movie: Movie) {
        if movie.poster == nil {
            ImageLoader.sharedInstance.loadImage((movie.movieId?.stringValue)!, imageURL: movie.posterURL(), completion: { (operation, imageData, error) -> (Void) in
                guard error == nil else {
                    return
                }

                if let image = imageData {
                    let movieId = NSNumber(long: (Int(operation.identifier))!)
                    print("Setting poster: \(movieId)")
                    Movie.setPoster(movieId, data: image, context: CoreDataStack.sharedInstance.context)
                    CoreDataStack.sharedInstance.save()
                }
            })

        }

        if movie.backdrop == nil {
            ImageLoader.sharedInstance.loadImage((movie.movieId?.stringValue)!, imageURL: movie.backdropURL(), completion: { (operation, imageData, error) -> (Void) in
                guard error == nil else {
                    return
                }

                if let image = imageData {
                    let movieId = NSNumber(long: (Int(operation.identifier))!)
                    print("Setting backdrop: \(movieId)")
                    Movie.setBackdrop(movieId, data: image, context: CoreDataStack.sharedInstance.context)
                    CoreDataStack.sharedInstance.save()
                }
            })
        }
    }

    func showLoadingIndicator() {
        view.alpha = 0.5
        view.userInteractionEnabled = false

        loadingIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: CGRectGetMidX(view.bounds) - 22, y: CGRectGetMidY(view.bounds) - 22),
            size: CGSize(width: 44, height: 44)))
        loadingIndicator!.startAnimating()
        loadingIndicator!.hidesWhenStopped = true
        navigationController?.view.addSubview(loadingIndicator!)
    }

    func hideLoadingIndicator() {
        UIView.animateWithDuration(0.24, animations: {
            self.view.alpha = 1.0
            self.loadingIndicator?.alpha = 0.0
        }) { (finished) in
            self.view.userInteractionEnabled = true
            self.loadingIndicator?.removeFromSuperview()
        }
    }


    // MARK - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            if sections.count == 0 {
                tableView.separatorStyle = .None
            } else {
                tableView.separatorStyle = .SingleLine
            }
            return sections.count
        }
        tableView.separatorStyle = .None
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let frcSection = sections[section]
            return frcSection.numberOfObjects
        }

        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Movie", forIndexPath: indexPath) as! MovieTableViewCell

        cell.prepareForReuse()

        if let movie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie {
            configureCell(cell, movie: movie)
        }

        return cell
    }

    func configureCell(cell: MovieTableViewCell, movie: Movie) {
        cell.movieId = movie.movieId
        cell.titleView?.text = movie.title
        cell.overviewView?.text = movie.overview
        if let poster = movie.poster {
            let image = UIImage(data: poster)
            cell.posterView?.image = image
        }

        if movie.watchlist == nil {
            cell.saveButton.setTitle("Save", forState: .Normal)
        } else {
            cell.saveButton.setTitle("Remove", forState: .Normal)
        }

        cell.saveButton.addTarget(self, action: #selector(saveUnsaveMovie), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func saveUnsaveMovie(sender: UIButton) {
        var supercell: AnyObject? = sender
        while supercell != nil {
            if let cell = supercell as? MovieTableViewCell, movieId = cell.movieId {
                if let existing = Movie.movieWithId(movieId, context: CoreDataStack.sharedInstance.context) {
                    if existing.watchlist != nil {
                        // Remove
                        Watchlist.removeMovie(existing)
                    } else {
                        // Add
                        Watchlist.saveMovie(existing)
                    }
                    CoreDataStack.sharedInstance.save()
                }
                break
            } else {
                if let view = supercell as? UIView {
                    supercell = view.superview!
                }
            }
        }

    }

    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let movie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie {
            let detail = MovieDetailViewController()
            detail.movie = movie
            navigationController?.pushViewController(detail, animated: true)
        } else {
            table.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        table.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        table.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                table.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

            if let newIndexPath = newIndexPath {
                table.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
}

