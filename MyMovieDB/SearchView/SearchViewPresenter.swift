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
        let sanitizedString = sanitizeString(text: title)
        RequestManager.sharedInstance.requestMovies(withTitle: sanitizedString)
        controller.goToResultsScreen()
    }
    
    func isTextValid(text: String) -> Bool {
        let sanitizedText =  sanitizeString(text: text)
        return !(sanitizedText == "")
    }
    
    func sanitizeString(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
