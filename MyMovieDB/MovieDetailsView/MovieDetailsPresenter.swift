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
    let disposeBag = DisposeBag()
    
    
    init(controller: MovieDetailsViewController) {
        self.controller = controller
//        setupDetailedMovieObserver()
    }
    
    /*func setupDetailedMovieObserver(){
        sharedRequestManager.detailedMovie.asObservable()
        .subscribe(onNext: {
            [unowned self] detailedMovie in
            if let movie = detailedMovie {
                self.controller.detailedMovie = detailedMovie
            }
        }).disposed(by: disposeBag)
    }*/
}
