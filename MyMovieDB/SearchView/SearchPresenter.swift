//
//  SearchPresenter.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

class SearchPresenter {
    var controller: SearchViewController
    var sharedRequestManager = RequestManager.sharedInstance
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
    
    func searchForMovie(withTitle title: String){
        if(self.isTextValid(text: title)){
            let sanitizedString = sanitizeString(text: title)
            sharedRequestManager.requestMovies(withTitle: sanitizedString, andPage: 1)
            controller.goToResultsScreen()
        } else {
            controller.shouldShowErrorLabel(status: true)
        }
    }
    
    func isTextValid(text: String) -> Bool {
        let sanitizedText =  sanitizeString(text: text)
        return !(sanitizedText == "")
    }
    
    func sanitizeString(text: String) -> String {
        var sanitizedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitizedString = sanitizedString.replacingOccurrences(of: " ", with: "")
        return sanitizedString
    }
    
    func resetMoviesList(){
        sharedRequestManager.resetMoviesList()
    }
}
