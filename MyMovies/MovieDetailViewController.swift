//
//  MovieDetailViewController.swift
//  MyMovies
//
//  Created by Eytan Biala on 7/13/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

//extension UITextView {
//    func _firstBaselineOffsetFromTop() {
//    }
//    func _baselineOffsetFromBottom() {
//    }
//}

class MovieDetailViewController: UIViewController {

    var movie: Movie!

    var imageView: UIImageView!
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        let imageHeight = view.bounds.size.height * 0.55

        let topPadding: CGFloat = 3
        let bottomPadding: CGFloat = 10
        let textViewHeight = view.bounds.size.height - imageHeight - (self.navigationController?.toolbar.frame.size.height)! - topPadding - bottomPadding

        imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: view.bounds.size.width, height: imageHeight)))
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.95
        view.addSubview(imageView)

        setImage()


        let lrPadding: CGFloat = 3
        let frame = CGRect(origin: CGPoint(x: lrPadding, y: imageHeight + topPadding),
                           size: CGSize(width: view.bounds.size.width - (lrPadding*2), height: textViewHeight))
        textView = UITextView(frame: frame)
        textView.editable = false
        textView.scrollEnabled = true
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

        var str = movie.overview
        if str?.characters.count == 0 {
            str = ""
        }
        if let pop = movie.popularity {
            str = str! + "\n\n"
            str = str! + String(format: "Rating: %.f", pop.floatValue)
        }
        textView.text = str
        view.addSubview(textView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        title = movie.title

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        textView.flashScrollIndicators()
    }

    func setImage() {
        if let data = movie.backdrop, image = UIImage(data: data) {
            imageView.image = image
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)

        setImage()
    }
//    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        
//    }

    
}
