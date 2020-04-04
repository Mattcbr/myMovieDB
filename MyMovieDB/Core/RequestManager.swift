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
    let apiKey = "561efb6a"
    let moviesList: BehaviorRelay <[Movie]> = BehaviorRelay(value:[])
    let detailedMovie: BehaviorRelay <DetailedMovie?> = BehaviorRelay(value: nil)
    var imagesDict: [String: UIImage] = [:]
    
    func requestMovies(withTitle title:String) {
        let requestURL = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(title)"
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):
                do {
                    print("Got it, JSON:\(JSON)")
                    guard let data = response.data else {return}
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    print("Got Movie")
                    let newValue = self.moviesList.value + searchResults.Search
                    self.moviesList.accept(newValue)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
//                self.delegate?.didFailToLoadPopularMovies(withError: error)
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    func requestDetails(forMovie movie:Movie) {
        let requestURL = "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(movie.imdbID)&plot=full"
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):
                do {
                    print("Got it, JSON:\(JSON)")
                    guard let data = response.data else {return}
                    let decoder = JSONDecoder()
                    let detailedMovie = try decoder.decode(DetailedMovie.self, from: data)
                    self.detailedMovie.accept(detailedMovie)
                    print("Got Detailed Movie")
                } catch let error {
                    print(error)
                }
            case .failure(let error):
//                self.delegate?.didFailToLoadPopularMovies(withError: error)
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    func requestImage(forMovie movie: Movie, completion: @escaping (_ image: UIImage) -> Void) {
        if (movie.Poster == "N/A") {
            let defaultImage = UIImage(named: "appIconDefault")
            if let image = defaultImage {
                completion(image)
            }
        } else if let image = imagesDict[movie.imdbID] {
            completion(image)
        } else {
            Alamofire.request(movie.Poster).responseImage { response in
                if let image = response.result.value {
                    self.imagesDict[movie.imdbID] = image
                    completion(image)
                }
            }
        }
    }
    
    //MARK: Reset
    func resetMoviesList() {
        moviesList.accept([])
        resetSelectedMovie()
    }
    
    func resetSelectedMovie() {
        detailedMovie.accept(nil)
    }
}
