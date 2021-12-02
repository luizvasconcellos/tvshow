//
//  SearchPeopleCollectionViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 30/11/21.
//

import UIKit
import RxSwift

private let reuseIdentifier = "Cell"

class SearchPeopleCollectionViewController: UICollectionViewController {

    // MARK: - UI Elements
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "search tv people..."
        
        return view
    }()
    
    // MARK: - Properties
    var viewModel: PeopleViewModelProtocol?
    
    private let reuseIdentifier = "PersonCell"
    private var disposeBag = DisposeBag()
    private var people: People = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addObservable()
        setupUI()
        searchBar.delegate = self
    }
    
    // MARK: - add Observable
    private func addObservable() {
        viewModel?.searchPeopleError.asObservable().skip(1).subscribe(onNext: { _ in
            self.people = []
            print("ERROR ON REQUEST")
            ToastMessage.show(message: "Sorry, we had an internal problem to perform your search :( Please, try again later",
                              position: .bottom,
                              type: .error)
        }).disposed(by: disposeBag)
        
        viewModel?.searchPeopleSuccess.asObservable().skip(1).subscribe(onNext: { [weak self] people in
            guard let self = self,
            let people = people else { return }
            
            self.people = people
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        navigationItem.title = "TV Show"
        navigationItem.titleView = searchBar
    }
    
    private func searchPeople(searchTerm: String) {
        viewModel?.searchPeople(with: searchTerm)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SearchPeopleCollectionViewCell else {
            return HomeCollectionViewCell()
        }
        cell.setup(with: people[indexPath.row])
        return cell
    }
}

// MARK: - CollectionView Flow Layout Delegate
extension SearchPeopleCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsPerRow: CGFloat = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - UISearchBarDelegate
extension SearchPeopleCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchText.isEmpty else {
            ToastMessage.show(message: "Please, inform a valid name for search.",
                              position: .bottom,
                              type: .error)
            return
        }
        searchPeople(searchTerm: searchTerm)
    }
}
