//
//  DetailedMovie.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

struct DetailedMovie: Codable {
    var Title: String
    var Year: String
    var Genre: String
    var Director: String
    var imdbID: String
    var Plot: String
    var Ratings: [Rating]
}
