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
    
    //MARK: Initialization
    init(controller: SearchViewController) {
        self.controller = controller
    }
    
    //MARK: Movie Request
    
    /**
    Makes a request to search for a movie.
    - Parameter title: The title to search for.
    */
    func searchForMovie(withTitle title: String){
        if(self.isTextValid(text: title)){
            let sanitizedString = sanitizeString(text: title)
            sharedRequestManager.requestMovies(withTitle: sanitizedString, andPage: 1)
            controller.goToResultsScreen()
        } else {
            controller.shouldShowErrorLabel(status: true)
        }
    }
    
    //MARK: Validation and Sanitization
    
    /**
    Validates a text.
    - Parameter text: The string to be validated.
    - Returns: A boolean indicating if the text is valid.
    */
    func isTextValid(text: String) -> Bool {
        let sanitizedText =  sanitizeString(text: text)
        return !(sanitizedText == "")
    }
    
    /**
    Sanitizes a text.
    - Parameter text: The string to be sanitized.
    - Returns: The input string after sanitization.
    */
    func sanitizeString(text: String) -> String {
        var sanitizedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitizedString = sanitizedString.replacingOccurrences(of: " ", with: "")
        return sanitizedString
    }
    
    /**
    Asks the *requestManager* to reset its movies list.
    */
    func resetMoviesList(){
        sharedRequestManager.resetMoviesList()
    }
}
