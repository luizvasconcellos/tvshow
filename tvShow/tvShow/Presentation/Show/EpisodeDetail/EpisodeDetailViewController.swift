//
//  EpisodeDetailViewController.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 27/11/21.
//

import UIKit
import Kingfisher

class EpisodeDetailViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var showPoster: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var name: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        view.textColor = .darkGray
        
        return view
    }()
    
    private lazy var summary: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .justified
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    // MARK: - Properties
    var episode: Episode? {
        didSet {
            bindUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let seasonNumber = episode?.season,
           let episodeNumber = episode?.number {
            navigationItem.title = "S\(seasonNumber) Ep\(episodeNumber)"
        }
        setupUI()
    }
    
    // MARK: - Private Functions
    private func setupUI() {

        view.addSubview(contentView)
        contentView.addSubview(showPoster)

        contentView.addSubview(name)
        contentView.addSubview(summary)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            showPoster.topAnchor.constraint(equalTo: contentView.topAnchor),
            showPoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showPoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: showPoster.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            summary.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            summary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summary.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            summary.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    private func bindUI() {
        
        if let seasonNumber = episode?.season,
           let episodeNumber = episode?.number,
           let episodeName = episode?.name{
            name.text = "S\(seasonNumber) Ep\(episodeNumber) - \(episodeName)"
        }
        
        summary.text = episode?.summary?.removeHtml()
        displayImage()
    }
    
    private func displayImage() {
        if let imageUrl = episode?.image?.medium {
            KF.url(URL(string: imageUrl))
                .cacheOriginalImage(true)
                .waitForCache(true)
                .onSuccess({ (result) in }).set(to: showPoster)
            return
        }
    }
}
