//
//  RequestManager.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa

class RequestManager {
    static let sharedInstance = RequestManager()
//    weak var delegate: RequestDelegate?
    let apiKey = "561efb6a"
//    let responseParser = Parser.shared
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let MoviesList: BehaviorRelay <[Movie]> = BehaviorRelay(value:[])
    
    func requestMovies(withTitle title:String) {
        let requestURL = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(title)&plot=full"
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):
                do {
                    print("Got it, JSON:\(JSON)")
                    guard let data = response.data else {return}
                    let searchResults = try self.decoder.decode(SearchResults.self, from: data)
                    print("Got Movie")
                    let newValue = self.MoviesList.value + searchResults.Search
                    self.MoviesList.accept(newValue)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
//                self.delegate?.didFailToLoadPopularMovies(withError: error)
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    func requestImage(imagePath: String, completion: @escaping (_ image: UIImage) -> Void) {
        let fullURL = "https://image.tmdb.org/t/p/w500/\(imagePath)"
        Alamofire.request(fullURL).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}
