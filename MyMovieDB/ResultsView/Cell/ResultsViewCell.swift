//
//  ResultsViewCell.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import UIKit

class ResultsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var requestManager = RequestManager.sharedInstance
    
    /**
    Sets the cell appearance according to a movie.
    - Parameter movie: The movie for which the cell should be set up.
    */
    func setup(forMovie movie:Movie){
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.startAnimating()
        
        self.movieNameLabel.text = movie.Title
        self.movieYearLabel.text = movie.Year
        
        requestManager.requestImage(forMovie: movie) { (image) in
            self.moviePosterImageView.image = image
            self.loadingActivityIndicator.stopAnimating()
        }
    }
}
