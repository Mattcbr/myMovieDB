//
//  Movie.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var Title: String
    var Year: String
    var imdbID: String
    var Poster: String
}
