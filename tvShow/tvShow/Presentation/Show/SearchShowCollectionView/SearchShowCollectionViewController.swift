//
//  SearchShowCollectionViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 30/11/21.
//

import UIKit

class SearchShowCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var shows: Shows?
    private let reuseIdentifier = "ShowCell"
    
    // MARK: - Public Functions
    func setup(shows: Shows) {
        self.shows = shows
    }
    
    // MARK: UICollectionViewDataSource & Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeCollectionViewCell,
              let show = shows?[indexPath.row]else {
            return HomeCollectionViewCell()
        }
    
        cell.setup(with: show)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController {
            
            vc.show = shows?[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - CollectionView Flow Layout Delegate
extension SearchShowCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func updateShows(shows: Shows) {
        self.shows = shows
        collectionView.reloadData()
    }
}
