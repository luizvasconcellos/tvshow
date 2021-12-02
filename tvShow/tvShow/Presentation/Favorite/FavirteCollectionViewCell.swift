//
//  FavirteCollectionViewCell.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 30/11/21.
//

import UIKit

class FavirteCollectionViewCell: SearchShowCollectionViewController {

    // MARK: - Properties
    var viewModel: ShowViewModelProtocol?
    
    private let reuseIdentifier = "ShowCell"
    private var shows: Shows = [] {
        didSet {
            setup(shows: shows)
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteList()
    }
    
    // MARK: - Private Functions
    private func searchShows(searchTerm: String) {
        viewModel?.searchShows(with: searchTerm)
    }
    
    private func getFavoriteList() {
        shows = UserDefaultsManager.shared.getUserFavoriteList()
    }
    
}
