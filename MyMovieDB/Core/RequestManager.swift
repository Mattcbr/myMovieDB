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
    let moviesListRequestError: BehaviorRelay<RequestError?> = BehaviorRelay(value: nil)
    let detailedMovie: BehaviorRelay <DetailedMovie?> = BehaviorRelay(value: nil)
    let detailedMovieRequestError: BehaviorRelay<RequestError?> = BehaviorRelay(value: nil)
    var imagesDict: [String: UIImage] = [:]
    var lastTitle = String()
    
    //MARK: Requests
    
    /**
    Gets the movies according to a given term.
    - Parameter title: The term to search for.
    - Parameter page: The API's page to request.
    */
    func requestMovies(withTitle title:String?, andPage page: Int) {
        var titleToSearch = lastTitle
        if let validTitle = title{
            titleToSearch = validTitle
            lastTitle = validTitle
        }
        let requestURL = "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(titleToSearch)&page=\(page)"
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):
                let decoder = JSONDecoder()
                guard let data = response.data else {return}
                let initialMovieCount = self.moviesList.value.count
                do {
                    print("Got it, JSON:\(JSON)")
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    print("Got Movie")
                    let newValue = self.moviesList.value + searchResults.Search
                    self.moviesList.accept(newValue)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                if (self.moviesList.value.count == initialMovieCount && page == 1){
                    do {
                        let requestError = try decoder.decode(RequestError.self, from: data)
                        self.moviesListRequestError.accept(requestError)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    /**
    Gets the details of a given movie.
    - Parameter movie: The movie to get the details.
    */
    func requestDetails(forMovie movie:Movie) {
        let requestURL = "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(movie.imdbID)&plot=full"
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    print("Got it, JSON:\(JSON)")
                    let detailedMovie = try decoder.decode(DetailedMovie.self, from: data)
                    self.detailedMovie.accept(detailedMovie)
                    print("Got Detailed Movie")
                } catch let error {
                    print(error)
                }
                
                if (self.detailedMovie.value == nil){
                    do {
                        let requestError = try decoder.decode(RequestError.self, from: data)
                        self.detailedMovieRequestError.accept(requestError)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    /**
    Gets the image associated to a given movie.
    - Parameter movie: The movie to get the image.
    - Parameter completion: The callback called after the retrieval of the image.
    - Parameter image: The movie's image.
    */
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
    
    //MARK: Sanitization
    
    /**
    Resets the movies list and the selected movie.
    */
    func resetMoviesList() {
        moviesList.accept([])
        moviesListRequestError.accept(nil)
        lastTitle = ""
        resetSelectedMovie()
        imagesDict = [:]
    }
    
    /**
    Resets the selected movie.
    */
    func resetSelectedMovie() {
        detailedMovie.accept(nil)
        detailedMovieRequestError.accept(nil)
    }
}
