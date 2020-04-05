//
//  SearchPresenterTests.swift
//  MyMovieDBTests
//
//  Created by Matheus Queiroz on 4/5/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import XCTest
@testable import MyMovieDB

class SearchPresenterTests: XCTestCase {

    var searchView: SearchViewController?
    var searchPresenter: SearchPresenter?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        searchView = storyboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController
        _ = searchView?.view
        
        searchPresenter = searchView?.presenter
    }

    override func tearDown() {
        searchView = nil
        searchPresenter = nil
    }

    func testSearchForValidMovieTitle(){
        let isListInInitialState = searchPresenter?.sharedRequestManager.moviesList.value.count == 0
        XCTAssertTrue(isListInInitialState)
        
        let validMovieTitle = "Cars"
        searchPresenter?.searchForMovie(withTitle: validMovieTitle)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        let didListCountChange = searchPresenter?.sharedRequestManager.moviesList.value.count ?? 0 > 0
        
        XCTAssertTrue(didListCountChange)
    }
    
    func testSearchForInvalidMovieTitle(){
        let notValidMovieTitle = "           "
        searchPresenter?.searchForMovie(withTitle: notValidMovieTitle)
        XCTAssertFalse(searchView?.errorLabel.isHidden ?? true)
    }
    
    func testForValidString() {
        let validString = "Test"
        let isStringValid = searchPresenter?.isTextValid(text: validString)
        XCTAssertTrue(isStringValid ?? false)
    }
    
    func testForNotValidString() {
        let notValidString = "           "
        let isStringValid = searchPresenter?.isTextValid(text: notValidString)
        XCTAssertFalse(isStringValid ?? true)
    }
    
    func testStringSanitizing() {
        let stringToSanitize = "   \n T E S T  S T R I N G        "
        let sanitizedString = searchPresenter?.sanitizeString(text: stringToSanitize)
        let expectedString = "TESTSTRING"
        XCTAssertEqual(sanitizedString, expectedString)
    }
    
    func testResettingMoviesList(){
        let moviesListInitialCount = searchPresenter?.sharedRequestManager.moviesList.value.count

        let validMovieTitle = "Cars"
        searchPresenter?.searchForMovie(withTitle: validMovieTitle)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        let moviesListSecondCount = searchPresenter?.sharedRequestManager.moviesList.value.count
        XCTAssertNotEqual(moviesListInitialCount, moviesListSecondCount)
        
        searchPresenter?.resetMoviesList()
        let isListReset = searchPresenter?.sharedRequestManager.moviesList.value.count == 0
        XCTAssertTrue(isListReset)
    }
}
