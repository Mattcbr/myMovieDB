//
//  ResultsPresenter.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ResultsPresenter {
    
    var controller: ResultsViewController
    var moviesList: [Movie] = []
    let sharedRequestManager = RequestManager.sharedInstance
    let disposeBag = DisposeBag()
    var pageToRequest: Int = 1
    
    init(controller: ResultsViewController) {
        self.controller = controller
        
        setupMoviesObserver()
        setupMoviesListErrorObserver()
        setupDetailedMovieObserver()
        setupDetailedMoviesErrorObserver()
    }
    
    func didSelectMovie(movie: Movie){
        RequestManager.sharedInstance.requestDetails(forMovie: movie)
    }
    
    //MARK: RX
    
    func setupMoviesObserver(){
        RequestManager.sharedInstance.moviesList.asObservable()
            .subscribe(onNext: {
                [unowned self] movies in
                self.moviesList = movies
                self.controller.didupdateMoviesList()
            }).disposed(by: disposeBag)
    }
    
    func setupMoviesListErrorObserver(){
        sharedRequestManager.moviesListRequestError.asObservable()
            .subscribe(onNext: {
                [unowned self] error in
                if let requestError = error {
                    self.controller.displayErrorAlert(forError: requestError,
                                                      withTitle: "Error Requesting Movies List",
                                                      shouldNavigateBack: true)
                }
            }).disposed(by: disposeBag)
    }
    
    func setupDetailedMoviesErrorObserver(){
        sharedRequestManager.detailedMovieRequestError.asObservable()
            .subscribe(onNext: {
                [unowned self] error in
                if let requestError = error {
                    self.controller.displayErrorAlert(forError: requestError,
                                                      withTitle: "Error Requesting Movie Details",
                                                      shouldNavigateBack: false)
                }
            }).disposed(by: disposeBag)
    }
    
    func setupDetailedMovieObserver(){
        sharedRequestManager.detailedMovie.asObservable()
            .subscribe(onNext: {
                [unowned self] detailedMovie in
                if let movie = detailedMovie {
                    self.controller.presentDetailsVC(forMovie: movie)
                }
            }).disposed(by: disposeBag)
    }
    
    func resetDetailedMovie(){
        sharedRequestManager.resetSelectedMovie()
    }
    
    func requestMoreMovies(){
        pageToRequest = pageToRequest + 1
        sharedRequestManager.requestMovies(withTitle: nil, andPage: pageToRequest)
    }
}