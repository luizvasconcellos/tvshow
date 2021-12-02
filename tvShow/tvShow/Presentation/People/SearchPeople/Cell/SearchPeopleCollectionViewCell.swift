//
//  SearchPeopleCollectionViewCell.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 30/11/21.
//

import UIKit
import Kingfisher

class SearchPeopleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    
    // MARK: - UI Elements
    private lazy var content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var name: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    // MARK: - Properties
    private var person: Person?
    
    // MARK: - Setup
    func setup(with person: Person) {
        self.person = person
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        personImage.backgroundColor = .white
        personName.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    // MARK: - Private Functions
    private func setupUIC() {
        
        addSubview(content)
        content.addSubview(image)
        content.addSubview(name)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: content.topAnchor),
            image.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: content.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 4),
            name.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            name.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -4)
        ])
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        name.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private func bindUI() {
        guard let person = person?.person else { return }
        personName.text = person.name
        if let imageUrl = person.image?.medium {
            KF.url(URL(string: imageUrl))
                .cacheOriginalImage(true)
                .waitForCache(true)
                .onSuccess({ (result) in }).set(to: personImage)
            return
        } else {
            personImage.image = UIImage(named: "no_image")
        }
    }
}
