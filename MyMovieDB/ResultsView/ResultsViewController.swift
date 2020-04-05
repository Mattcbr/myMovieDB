//
//  ResultsViewController.swift
//  MyMovieDB
//
//  Created by Matheus Queiroz on 4/4/20.
//  Copyright © 2020 mattcbr. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ResultsViewController: UICollectionViewController {
    
    var presenter: ResultsPresenter?
    var detailedMovie: DetailedMovie?
    let disposeBag = DisposeBag()
    var isLoadingData:Bool = true
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ResultsPresenter(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        presenter?.resetDetailedMovie()
    }
    
    //MARK: Controller
    
    func presentDetailsVC(forMovie movie: DetailedMovie){
        detailedMovie = movie
        self.performSegue(withIdentifier: "movieDetailsSegue", sender: self)
    }
    
    func didupdateMoviesList(){
        self.collectionView.reloadData()
        self.isLoadingData = false
    }
    
    func displayErrorAlert(forError error: RequestError, withTitle title:String, shouldNavigateBack navigateBack:Bool) {
        let alert = UIAlertController(title: title,
                                      message: error.Error,
                                      preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "Back", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        if(navigateBack){
            alert.addAction(backAction)
        } else {
            alert.addAction(acceptAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
   // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.moviesList.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? ResultsViewCell else {
            fatalError("Not a details cell")
        }
    
        if let movieToDisplay = presenter?.moviesList[indexPath.row] {
            cell.setup(forMovie:movieToDisplay)
        }
        
        //cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedMovie = presenter?.moviesList[indexPath.row] {
            self.presenter?.didSelectMovie(movie: selectedMovie)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "movieDetailsSegue"){
            guard let destinationVc = segue.destination as? MovieDetailsViewController else {return}
            if let movie = detailedMovie {
                destinationVc.detailedMovie = movie
            }
        }
    }
    
    //MARK: Infinite Scroll
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        let diff = scrollContentSizeHeight - scrollOffset - scrollViewHeight    //This detects if the scroll is near the botom of the scroll view
        
        
        if (diff<30 && !isLoadingData)    //If the scroll is near the bottom, and there is no data being loaded, make a new request.
        {
            presenter?.requestMoreMovies()
            isLoadingData = true
        }
    }
}
