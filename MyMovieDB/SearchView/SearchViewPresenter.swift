//
//  SearchViewPresenter.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

class SearchViewPresenter {
    var controller: SearchViewController
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
    
    func searchForMovie(withTitle title: String){
        RequestManager.sharedInstance.requestMovies(withTitle: title)
        controller.goToResultsScreen()
    }
}
