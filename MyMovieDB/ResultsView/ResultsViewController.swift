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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.dataSource = nil
        setupMoviesObserver()
//        setupCellConfiguration()
    }
    
    func setupMoviesObserver(){
        RequestManager.sharedInstance.MoviesList.asObservable()
            .subscribe(onNext: {
                [unowned self] movies in
                self.moviesList = movies
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    /*func setupCellConfiguration() {
      moviesList
        .bind(to: self.collectionView
          .rx
          .items(cellIdentifier: "MovieCell",
                 cellType: ResultsViewCell.self)) { row, movie, cell in
                    cell.movieNameLabel.text = movie.Title
        }
        .disposed(by: disposeBag)
    }*/
    
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
}
