//
//  MovieDetailsViewController.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieDirectorsLabel: UILabel!
    @IBOutlet weak var movieRatingsLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var IMDBRatingView: UIView!
    @IBOutlet weak var IMDBRatingLabel: UILabel!
    @IBOutlet weak var RTRatingView: UIView!
    @IBOutlet weak var RTRatingLabel: UILabel!
    @IBOutlet weak var MCRatingView: UIView!
    @IBOutlet weak var MCRatingLabel: UILabel!
    
    var presenter: MovieDetailsPresenter?
    var sharedRequestManager = RequestManager.sharedInstance
    var detailedMovie: DetailedMovie?
        /*didSet {
            if let movie = detailedMovie {
                setup(forMovie: movie)
            }
        }*/
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
//        self.presenter = MovieDetailsPresenter(controller: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        //Do loader, blur and else here
        super.viewDidLoad()
        self.presenter = MovieDetailsPresenter(controller: self)
        if let movie = detailedMovie{
            setup(forMovie: movie)
        }
    }
    
    func setup(forMovie movie: DetailedMovie){
        setupImage()
        setupRatings()
        
        self.navigationItem.title = movie.Title
        movieTitleLabel.text = movie.Title
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.sizeToFit()
        
        movieYearLabel.text = movie.Year
        movieYearLabel.numberOfLines = 0
        movieYearLabel.sizeToFit()
        
        movieGenreLabel.text = "Genre(s):\n\(movie.Genre)"
        movieGenreLabel.numberOfLines = 0
        movieGenreLabel.sizeToFit()
        
        movieDirectorsLabel.text = "Directed by:\n\(movie.Director)"
        movieDirectorsLabel.numberOfLines = 0
        movieDirectorsLabel.sizeToFit()
        
        movieRatingsLabel.text = "Available Ratings"
        movieRatingsLabel.numberOfLines = 0
        movieRatingsLabel.sizeToFit()
        
        movieDescriptionLabel.text = movie.Plot
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.sizeToFit()
    }
    
    func setupImage(){
        if let movieID = detailedMovie?.imdbID{
            self.moviePosterImageView.image = sharedRequestManager.imagesDict[movieID]
        }
    }
    
    func setupRatings(){
        hideRatingViews()
        guard let movie = detailedMovie else {return}
        for rating in movie.Ratings{
            switch rating.Source {
            case "Internet Movie Database":
                IMDBRatingView.isHidden = false
                IMDBRatingLabel.text = "IMDB:\n\(rating.Value)"
                IMDBRatingLabel.numberOfLines = 0
                IMDBRatingLabel.sizeToFit()
            case "Rotten Tomatoes":
                RTRatingView.isHidden = false
                RTRatingLabel.text = "RT:\n\(rating.Value)"
                RTRatingLabel.numberOfLines = 0
                RTRatingLabel.sizeToFit()
            case "Metacritic":
                MCRatingView.isHidden = false
                MCRatingLabel.text = "Metacritic:\n\(rating.Value)"
                MCRatingLabel.numberOfLines = 0
                MCRatingLabel.sizeToFit()
            default:
                print("Other Rating Found: \(rating.Source)")
            }
        }
    }
    
    func hideRatingViews(){
        self.IMDBRatingView.isHidden = true
        self.RTRatingView.isHidden = true
        self.MCRatingView.isHidden = true
    }
}