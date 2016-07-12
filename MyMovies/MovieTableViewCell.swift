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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        titleView.font = UIFont(descriptor: UIFontDescriptor, size: <#T##CGFloat#>)
        overviewView?.textColor = UIColor.lightGrayColor()
        overviewView?.numberOfLines = 3

        posterView?.contentMode = .ScaleAspectFit
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleView?.text = nil
        overviewView?.text = nil
        posterView?.image = nil
    }
    
}
