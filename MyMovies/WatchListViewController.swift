//
//  WatchListViewController.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/13/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import CoreData

class WatchListViewController: ViewController {

    lazy var emptyView : UILabel = {
        let label = UILabel()
        label.text = "No Saved Movies"
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        return label
    }()

    override func getFetchedResultsController() -> NSFetchedResultsController {
        let frc = Watchlist.fetchedResultsController(CoreDataStack.sharedInstance.context)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let fetchError as NSError {
            print(fetchError)
        }

        return frc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
    }

    override func loadData() {
        // does nothing, FRC handles loading
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Movie", forIndexPath: indexPath) as! MovieTableViewCell

        cell.prepareForReuse()

        if let watchlist = fetchedResultsController.objectAtIndexPath(indexPath) as? Watchlist, movie = watchlist.movie {
            configureCell(cell, movie: movie)
        }

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.fetchedObjects?.count {
            if (count == 0) {
                tableView.separatorStyle = .None
                tableView.backgroundView = emptyView
                emptyView.frame = tableView.bounds
            } else {
                tableView.separatorStyle = .SingleLine
                tableView.backgroundView = nil
            }
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }
}

