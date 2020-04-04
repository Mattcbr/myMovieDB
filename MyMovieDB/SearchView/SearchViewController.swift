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
    @IBOutlet weak var searchButton: UIButton!
    var presenter: SearchViewPresenter?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SearchViewPresenter(controller: self)
        movieSearchBar.delegate = self
        
        searchButton.isEnabled = false
        searchButton.layer.cornerRadius = 10
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let isValid = self.presenter?.isTextValid(text: searchText) else {return}
        if isValid != self.searchButton.isEnabled {
            self.searchButton.isEnabled = isValid
        }
    }
    
    @IBAction func didPressSearchButton(_ sender: Any) {
        if let movieToSearch = movieSearchBar.text {
            print("Movie to search: \(movieToSearch)")
            presenter?.searchForMovie(withTitle: movieToSearch)
        } else {
            //TODO: Add Warning
        }
    }
    
    //MARK: Other
    func goToResultsScreen(){
        self.performSegue(withIdentifier: "showResultsSegue", sender: self)
    }
}
