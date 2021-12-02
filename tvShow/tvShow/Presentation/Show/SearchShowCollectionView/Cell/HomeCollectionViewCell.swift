//
//  HomeCollectionViewCell.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    private var show: Show?
    private let favoriteImage = UIImage(systemName: "heart.fill")
    
    // MARK: - Setup
    func setup(with show: Show) {
        self.show = show
        setupUI()
        bindUI()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        showImage.backgroundColor = .white
        showName.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        favoriteButton.addTarget(self, action: #selector(self.saveFavoriteAction), for: .touchUpInside)
    }
    
    private func bindUI() {
        guard let show = show else { return }
        showName.text = show.show?.name
        if let imageUrl = show.show?.image?.medium {
            KF.url(URL(string: imageUrl))
                .cacheOriginalImage(true)
                .waitForCache(true)
                .onSuccess({ (result) in }).set(to: showImage)
        } else {
            showImage.image = UIImage(named: "no_image")
        }
        
        if UserDefaultsManager.shared.isFavorited(show: show) {
            favoriteButton.setImage(favoriteImage?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
            return
        }
        favoriteButton.setImage(favoriteImage?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc func saveFavoriteAction() {
        saveFavorite()
    }
    private func saveFavorite() {
        guard let show = show else { return }
        if UserDefaultsManager.shared.isFavorited(show: show) {
            if UserDefaultsManager.shared.removeFromFavorite(show: show) {
                favoriteButton.setImage(favoriteImage?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal), for: .normal)
                ToastMessage.show(message: "The TV Show was removed from your favorite list with success.",
                                  position: .bottom,
                                  type: .success)
            } else {
                ToastMessage.show(message: "We had a problem to remove this Show from your list, please try again later.",
                                  position: .bottom,
                                  type: .error)
            }
            return
        }
        if UserDefaultsManager.shared.addToFavorite(show: show) {
            favoriteButton.setImage(favoriteImage?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
            ToastMessage.show(message: "The TV Show was included to your favorite list with success.",
                              position: .bottom,
                              type: .success)
        } else {
            ToastMessage.show(message: "We had a problem to include this Show from your list, please try again later.",
                              position: .bottom,
                              type: .error)
        }
        return
    }
}
