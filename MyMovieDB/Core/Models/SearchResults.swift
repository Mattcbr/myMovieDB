//
//  SearchResults.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    var Search: [Movie]
    var totalResults: String
    var Response: String
}
