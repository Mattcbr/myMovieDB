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
    
    var moviesList: [Movie] = []
    var presenter: ResultsViewPresenter?
    var detailedMovie: DetailedMovie?
    let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ResultsViewPresenter(controller: self)
        setupMoviesObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        presenter?.resetDetailedMovie()
    }
    
    //MARK: RX
    func setupMoviesObserver(){
        RequestManager.sharedInstance.moviesList.asObservable()
            .subscribe(onNext: {
                [unowned self] movies in
                self.moviesList = movies
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    /*
    func setupCellTapHandling(){
        self.collectionView.rx.modelSelected(Movie.self).subscribe(onNext:{ [unowned self] movie in
            if let selectedCellIndexPath = self.collectionView.indexPathsForSelectedItems {
                let selectedMovie = self.moviesList[selectedCellIndexPath[0].row]
                self.presenter?.didSelectMovie(movie: selectedMovie)
            }
            }).disposed(by: disposeBag)
    }
    func setupCellConfiguration() {
      moviesList
        .bind(to: self.collectionView
          .rx
          .items(cellIdentifier: "MovieCell",
                 cellType: ResultsViewCell.self)) { row, movie, cell in
                    cell.movieNameLabel.text = movie.Title
        }
        .disposed(by: disposeBag)
    }*/
    
    //MARK: Controller
    
    func presentDetailsVC(forMovie movie: DetailedMovie){
        detailedMovie = movie
        self.performSegue(withIdentifier: "movieDetailsSegue", sender: self)
    }
    
   // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? ResultsViewCell else {
            fatalError("Not a details cell")
        }
    
        let movieToDisplay = moviesList[indexPath.row]
        cell.setup(forMovie:movieToDisplay)
        
        //cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = self.moviesList[indexPath.row]
        self.presenter?.didSelectMovie(movie: selectedMovie)
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
}
