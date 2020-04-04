//
//  ResultsViewPresenter.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ResultsViewPresenter {
    
    var controller: ResultsViewController
    let sharedRequestManager = RequestManager.sharedInstance
    let disposeBag = DisposeBag()
    
    
    init(controller: ResultsViewController) {
        self.controller = controller
        
        setupDetailedMovieObserver()
    }
    
    func didSelectMovie(movie: Movie){
        print("Movie Selected")
        RequestManager.sharedInstance.requestDetails(forMovie: movie)
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
}
