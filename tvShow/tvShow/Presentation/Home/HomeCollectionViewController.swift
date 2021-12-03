//
//  HomeCollectionViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import UIKit
import RxSwift

class HomeCollectionViewController: SearchShowCollectionViewController, UISearchBarDelegate {

    // MARK: - UI Elements
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "search tv shows..."
        
        return view
    }()
    
    // MARK: - Properties
    var viewModel: ShowViewModelProtocol?
    
    private let reuseIdentifier = "ShowCell"
    private var disposeBag = DisposeBag()
    private var shows: Shows = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservable()
        setupUI()
        searchBar.delegate = self
        setup(shows: shows)
    }

    // MARK: - add Observable
    private func addObservable() {
        viewModel?.searchShowsError.asObservable().skip(1).subscribe(onNext: { _ in
            self.updateShows(shows: [])
            print("ERROR ON REQUEST")
        }).disposed(by: disposeBag)
        
        viewModel?.searchShowsSuccess.asObservable().skip(1).subscribe(onNext: { [weak self] shows in
            guard let self = self,
            let shows = shows else { return }
            
            self.updateShows(shows: shows)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        navigationItem.title = "TV Show"
        navigationItem.titleView = searchBar
    }
    
    private func searchShows(searchTerm: String) {
        viewModel?.searchShows(with: searchTerm)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchText.isEmpty else {
            ToastMessage.show(message: "Please, informa a valid TV Show name for search.",
                              position: .bottom,
                              type: .error)
            return
        }
        searchShows(searchTerm: searchTerm)
    }
}
