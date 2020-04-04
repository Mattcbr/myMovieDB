//
//  SearchViewController.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/3/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    var presenter: SearchViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SearchViewPresenter(controller: self)
        movieSearchBar.delegate = self
    }
    
    //MARK: Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let movieToSearch = searchBar.text {
            print("Movie to search: \(movieToSearch)")
            presenter?.searchForMovie(withTitle: movieToSearch)
        } else {
            //TODO: Add Warning
        }
    }
    
    func goToResultsScreen(){
        self.performSegue(withIdentifier: "showResultsSegue", sender: self)
    }
}
