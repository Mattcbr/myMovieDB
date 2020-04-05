//
//  RequestError.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/5/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation

struct RequestError: Codable {
    var Response: String
    var Error: String
}
