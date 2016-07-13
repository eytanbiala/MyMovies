//
//  MovieTableViewCell.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var overviewView: UILabel!
    @IBOutlet weak var starView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!

    var movieId: NSNumber?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        titleView.font = UIFont(descriptor: UIFontDescriptor, size: <#T##CGFloat#>)
//        titleView.numberOfLines = 2
        overviewView?.textColor = UIColor.lightGrayColor()
        overviewView?.numberOfLines = 4

        posterView?.contentMode = .ScaleAspectFit
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        movieId = nil

        titleView?.text = nil
        overviewView?.text = nil
        posterView?.image = nil

        saveButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    }
    
}
