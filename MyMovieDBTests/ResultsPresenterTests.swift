//
//  ResultsPresenterTests.swift
//  MyMovieDBTests
//
//  Created by Matheus Queiroz on 4/5/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import XCTest
@testable import MyMovieDB

class ResultsPresenterTests: XCTestCase {

    var resultsView: ResultsViewController?
    var resultsPresenter: ResultsPresenter?
    let testMovie = Movie(Title: "Titanic",
                          Year: "1997",
                          imdbID: "tt0120338",
                          Poster: "https://m.media-amazon.com/images/M/MV5BMDdmZGU3NDQtY2E5My00ZTliLWIzOTUtMTY4ZGI1YjdiNjk3XkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_SX300.jpg")
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        resultsView = storyboard.instantiateViewController(identifier: "ResultsViewController") as? ResultsViewController
        _ = resultsView?.view
        
        resultsPresenter = resultsView?.presenter
    }

    override func tearDown() {
        resultsView = nil
        resultsPresenter = nil
    }

    func testMovieSelecting() {
        resultsPresenter?.didSelectMovie(movie: testMovie)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        let detailedMovie = resultsPresenter?.sharedRequestManager.detailedMovie.value
        XCTAssertEqual(testMovie.Title, detailedMovie?.Title)
    }
    
    func testDetailedMovieResetting() {
        resultsPresenter?.didSelectMovie(movie: testMovie)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        let detailedMovie = resultsPresenter?.sharedRequestManager.detailedMovie.value
        XCTAssertEqual(testMovie.Title, detailedMovie?.Title)
        
        resultsPresenter?.resetDetailedMovie()
        XCTAssertNil(resultsPresenter?.sharedRequestManager.detailedMovie.value)
    }
    
    func testRequestMoreMovies() {
        XCTAssertEqual(resultsPresenter?.moviesList.count, 0)
        
        resultsPresenter?.sharedRequestManager.lastTitle = "Avatar"
        resultsPresenter?.requestMoreMovies()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        XCTAssertNotEqual(resultsPresenter?.moviesList.count, 0)
    }
    
}
