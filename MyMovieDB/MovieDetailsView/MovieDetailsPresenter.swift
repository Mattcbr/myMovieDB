//
//  MovieDetailsPresenter.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MovieDetailsPresenter {
    var controller: MovieDetailsViewController
    let sharedRequestManager = RequestManager.sharedInstance
    
    //MARK: Initialization
    
    init(controller: MovieDetailsViewController) {
        self.controller = controller
    }
    
    //MARK: Image Handling
    
    /**
    Gets the movie's poster from the *requestManager*
    - Parameter movie: The movie for which the poster should be requested.
    */
    func getImageForDetailedMovie(movie: DetailedMovie){
        let movieID = movie.imdbID
        var movieImage = UIImage(named: "appIconDefault")
        if let moviePoster = sharedRequestManager.imagesDict[movieID] {
            movieImage = moviePoster
        }
        if let image = movieImage {
            self.controller.setupPosterImageView(withImage: image)
        }
    }
}
