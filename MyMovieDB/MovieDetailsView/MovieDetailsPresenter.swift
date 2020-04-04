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
    
    init(controller: MovieDetailsViewController) {
        self.controller = controller
    }
    
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
